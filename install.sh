#!/usr/bin/env bash

set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$REPO_DIR/.tmp"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$LOG_DIR/install-$TIMESTAMP.log"
CURRENT_STAGE="initialization"
PYTHON_VERSION="3.13.2"
PAWLETTE_COMMIT="823e1c16304c812278ed27e05533008896a3ada7"
SDDM_ASTRONAUT_COMMIT="abb3163c724935af888ba5ea9ac0c4f22afd8048"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

on_error() {
    local rc=$?
    local line="${BASH_LINENO[0]:-${LINENO}}"

    printf '\nERROR: stage "%s" failed at line %s (exit %s).\n' "$CURRENT_STAGE" "$line" "$rc" >&2
    printf 'Log: %s\n' "$LOG_FILE" >&2
    exit "$rc"
}

trap on_error ERR

stage() {
    CURRENT_STAGE="$1"
    printf '\n============================================================\n'
    printf '%s\n' "$CURRENT_STAGE"
    printf '============================================================\n'
}

require_file() {
    [[ -f "$1" ]] || {
        printf 'Required file not found: %s\n' "$1" >&2
        exit 1
    }
}

read_package_file() {
    local file="$1"
    grep -Ev '^[[:space:]]*(#|$)' "$file"
}

install_pacman_packages() {
    mapfile -t packages < <(read_package_file "$REPO_DIR/packages/pacman.txt")
    (("${#packages[@]}" > 0)) || return 0

    sudo pacman -Syu --needed --noconfirm "${packages[@]}"
}

install_hardware_packages() {
    local -a packages=(mesa)
    local vendors=""
    local product_name=""

    vendors="$({ cat /sys/class/drm/card*/device/vendor 2>/dev/null || true; } | sort -u)"
    product_name="$(cat /sys/class/dmi/id/product_name 2>/dev/null || true)"

    if grep -q '^0x1002$' <<< "$vendors"; then
        packages+=(xf86-video-amdgpu vulkan-radeon)
        printf 'GPU profile: AMD\n'
    fi

    if grep -q '^0x8086$' <<< "$vendors"; then
        packages+=(intel-media-driver libva-intel-driver libvpl vpl-gpu-rt vulkan-intel)
        printf 'GPU profile: Intel\n'
    fi

    if grep -q '^0x10de$' <<< "$vendors"; then
        packages+=(xf86-video-nouveau vulkan-nouveau)
        printf 'GPU profile: NVIDIA/Nouveau\n'
    fi

    if [[ "$product_name" == *VirtualBox* ]]; then
        packages+=(virtualbox-guest-utils)
        printf 'VirtualBox guest detected.\n'
    fi

    sudo pacman -S --needed --noconfirm "${packages[@]}"
}

install_build_dependencies() {
    sudo pacman -S --needed --noconfirm \
        bzip2 \
        libffi \
        openssl \
        readline \
        sqlite \
        xz \
        zlib
}

bootstrap_yay() {
    if command -v yay >/dev/null 2>&1; then
        printf 'yay already installed.\n'
        return 0
    fi

    local tmp_dir
    tmp_dir="$(mktemp -d)"

    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    (
        cd "$tmp_dir/yay"
        makepkg -si --noconfirm
    )

    rm -rf "$tmp_dir"
}

install_aur_packages() {
    mapfile -t packages < <(read_package_file "$REPO_DIR/packages/aur.txt")
    (("${#packages[@]}" > 0)) || return 0

    yay -S --needed --noconfirm "${packages[@]}"
}

install_dotfiles() {
    mkdir -p \
        "$HOME/.config" \
        "$HOME/.local" \
        "$HOME/.icons" \
        "$HOME/.xkb"

    cp -a "$REPO_DIR/.config/." "$HOME/.config/"
    cp -a "$REPO_DIR/.local/." "$HOME/.local/"
    cp -a "$REPO_DIR/.icons/." "$HOME/.icons/"
    cp -a "$REPO_DIR/.xkb/." "$HOME/.xkb/"

    # Preserve an existing .xprofile; on a clean install, install our X11 hook.
    if [[ -f "$REPO_DIR/.xprofile" ]]; then
        if [[ ! -e "$HOME/.xprofile" && ! -L "$HOME/.xprofile" ]]; then
            cp -a "$REPO_DIR/.xprofile" "$HOME/.xprofile"
        elif ! grep -Fq 'deskflow-client.service' "$HOME/.xprofile"; then
            printf 'NOTE: ~/.xprofile was preserved; add the Deskflow hook manually.\n'
        fi
    fi

    if [[ -e "$REPO_DIR/.zshenv" ]]; then
        cp -a "$REPO_DIR/.zshenv" "$HOME/.zshenv"
    fi

    find "$HOME/.local/bin" -type f -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$HOME/.config/bspwm/bspwmrc" 2>/dev/null || true
    find "$HOME/.config/bspwm/atno" -type f -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
}

install_deskflow_integration() {
    sudo install -Dm755 \
        "$REPO_DIR/system/usr/local/libexec/deskflow-sddm-watch" \
        /usr/local/libexec/deskflow-sddm-watch

    sudo install -Dm644 \
        "$REPO_DIR/system/etc/systemd/system/deskflow-sddm.service" \
        /etc/systemd/system/deskflow-sddm.service

    sudo systemctl daemon-reload
    systemctl --user daemon-reload

    printf 'Deskflow services installed but not activated.\n'
    printf 'Complete TLS enrollment in docs/DESKFLOW.md before enabling them.\n'
}

install_python_runtime() {
    export PYENV_ROOT="$HOME/.pyenv"

    pyenv install -s "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    local python_bin="$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python"

    "$python_bin" -m pip install --upgrade \
        pip \
        setuptools \
        psutil \
        GPUtil \
        pyamdgpuinfo
}

install_pawlette() {
    local python_bin="$HOME/.pyenv/versions/$PYTHON_VERSION/bin/python"
    local package="git+https://github.com/meowrch/pawlette.git@$PAWLETTE_COMMIT"

    if pipx list --short 2>/dev/null | grep -qx 'pawlette'; then
        pipx uninstall pawlette
    fi

    pipx install --python "$python_bin" "$package"
}

install_sddm_theme() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    git clone https://github.com/Keyitdev/sddm-astronaut-theme.git "$tmp_dir/sddm-astronaut-theme"
    git -C "$tmp_dir/sddm-astronaut-theme" checkout "$SDDM_ASTRONAUT_COMMIT"

    sudo rm -rf /usr/share/sddm/themes/sddm-astronaut-theme
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -a "$tmp_dir/sddm-astronaut-theme" /usr/share/sddm/themes/sddm-astronaut-theme

    if [[ -d "$tmp_dir/sddm-astronaut-theme/Fonts" ]]; then
        sudo mkdir -p /usr/share/fonts
        sudo cp -a "$tmp_dir/sddm-astronaut-theme/Fonts/." /usr/share/fonts/
        sudo fc-cache -f
    fi

    sudo install -Dm644 \
        "$REPO_DIR/system/etc/sddm.conf.d/10-theme.conf" \
        /etc/sddm.conf.d/10-theme.conf

    sudo install -Dm644 \
        "$REPO_DIR/system/etc/sddm.conf.d/20-virtualkbd.conf" \
        /etc/sddm.conf.d/20-virtualkbd.conf

    rm -rf "$tmp_dir"
}

enable_services() {
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
    sudo systemctl enable sddm.service

    if systemctl list-unit-files vboxservice.service >/dev/null 2>&1; then
        sudo systemctl enable vboxservice.service || true
    fi

    systemctl --user daemon-reload
    systemctl --user enable pipewire.socket
    systemctl --user enable pipewire-pulse.socket
    systemctl --user enable wireplumber.service
}

configure_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
        sudo chsh -s "$zsh_path" "$USER"
    fi
}

validate_installation() {
    local -a required_commands=(
        bspc
        sxhkd
        ghostty
        rofi
        polybar
        picom
        dunst
        deskflow-core
        nemo
        nvim
        yazi
        pyenv
        pipx
        yay
    )

    local failed=0
    local command_name

    for command_name in "${required_commands[@]}"; do
        if ! command -v "$command_name" >/dev/null 2>&1; then
            printf 'MISSING: %s\n' "$command_name"
            failed=1
        fi
    done

    [[ -x "$HOME/.pyenv/versions/$PYTHON_VERSION/bin/python" ]] || {
        printf 'MISSING: Python %s under pyenv\n' "$PYTHON_VERSION"
        failed=1
    }

    [[ -f /etc/systemd/system/deskflow-sddm.service ]] || {
        printf 'MISSING: SDDM Deskflow service\n'
        failed=1
    }

    [[ -f "$HOME/.config/systemd/user/deskflow-client.service" ]] || {
        printf 'MISSING: BSPWM Deskflow user service\n'
        failed=1
    }

    [[ -d /usr/share/sddm/themes/sddm-astronaut-theme ]] || {
        printf 'MISSING: sddm-astronaut-theme\n'
        failed=1
    }

    [[ "$failed" -eq 0 ]]
}

main() {
    if [[ "$EUID" -eq 0 ]]; then
        printf 'Run this installer as the normal desktop user, not as root.\n' >&2
        exit 1
    fi

    if [[ ! -f /etc/arch-release ]]; then
        printf 'This installer is intended for Arch Linux.\n' >&2
        exit 1
    fi

    require_file "$REPO_DIR/packages/pacman.txt"
    require_file "$REPO_DIR/packages/aur.txt"
    require_file "$REPO_DIR/system/etc/sddm.conf.d/10-theme.conf"
    require_file "$REPO_DIR/system/etc/sddm.conf.d/20-virtualkbd.conf"
    require_file "$REPO_DIR/.xprofile"
    require_file "$REPO_DIR/.config/systemd/user/deskflow-client.service"
    require_file "$REPO_DIR/system/usr/local/libexec/deskflow-sddm-watch"
    require_file "$REPO_DIR/system/etc/systemd/system/deskflow-sddm.service"

    stage '1/11 - sudo credentials'
    sudo -v

    stage '2/11 - native packages'
    install_pacman_packages
    install_build_dependencies

    stage '3/11 - hardware packages'
    install_hardware_packages

    stage '4/11 - yay bootstrap'
    bootstrap_yay

    stage '5/11 - AUR packages'
    install_aur_packages

    stage '6/11 - dotfiles'
    install_dotfiles

    stage '7/11 - Deskflow X11 integration (TLS setup remains opt-in)'
    install_deskflow_integration

    stage '8/11 - Python 3.13.2 and Python modules'
    install_python_runtime

    stage '9/11 - Pawlette'
    install_pawlette

    stage '10/11 - SDDM Astronaut and services'
    install_sddm_theme
    enable_services
    configure_shell

    stage '11/11 - validation'
    validate_installation

    printf '\nINSTALLATION COMPLETE\n'
    printf 'Repository: %s\n' "$REPO_DIR"
    printf 'Log:        %s\n' "$LOG_FILE"
    printf 'Python:     %s\n' "$HOME/.pyenv/versions/$PYTHON_VERSION/bin/python"
    printf 'SDDM theme: %s\n' '/usr/share/sddm/themes/sddm-astronaut-theme'
    printf 'Deskflow TLS setup: %s\n' 'docs/DESKFLOW.md'
    printf '\nDo not format the real machine yet. Reboot this clean test VM and validate the BSPWM session first.\n'
}

main "$@"
