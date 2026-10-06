#!/usr/bin/env bash

PICOM_CONFIG="$HOME/.config/picom/picom.conf"

# Xresources
if [[ -f "$HOME/.Xresources" ]] && command -v xrdb >/dev/null 2>&1; then
    xrdb -merge "$HOME/.Xresources"
fi

# XSettings
if command -v xsettingsd >/dev/null 2>&1; then
    pkill -x xsettingsd 2>/dev/null || true
    xsettingsd &
fi

# Notifications
if command -v dunst >/dev/null 2>&1; then
    pkill -x dunst 2>/dev/null || true
    dunst &
fi

# Picom
if command -v picom >/dev/null 2>&1 && [[ -f "$PICOM_CONFIG" ]]; then
    pkill -x picom 2>/dev/null || true

    GPU_PROFILE="${XDG_BIN_HOME:-$HOME/.local/bin}/gpu-detect-profile.sh"

    if [[ -x "$GPU_PROFILE" ]]; then
        GPU_SETUP="$("$GPU_PROFILE")"
    else
        GPU_SETUP="unknown"
    fi

    case "$GPU_SETUP" in
        nvidia-only|hybrid-intel-nvidia)
            picom \
                --backend glx \
                --xrender-sync-fence \
                --glx-no-rebind-pixmap \
                --config "$PICOM_CONFIG" &
            ;;

        amd-only|hybrid-amd-intel)
            picom \
                --backend glx \
                --config "$PICOM_CONFIG" &
            ;;

        intel-only)
            picom \
                --backend glx \
                --glx-no-rebind-pixmap \
                --config "$PICOM_CONFIG" &
            ;;

        nouveau-only|hybrid-intel-nouveau)
            picom \
                --backend glx \
                --config "$PICOM_CONFIG" &
            ;;

        *)
            picom \
                --backend glx \
                --config "$PICOM_CONFIG" &
            ;;
    esac
fi

# Polybar
if [[ -x "$HOME/.config/polybar/launch.sh" ]]; then
    "$HOME/.config/polybar/launch.sh" &
fi

# Polkit authentication agent
POLKIT_SCRIPT="${XDG_BIN_HOME:-$HOME/.local/bin}/polkit-agent.sh"

if [[ -f "$POLKIT_SCRIPT" ]]; then
    sh "$POLKIT_SCRIPT" &
fi

# Wallpaper
WALLPAPER_SCRIPT="${XDG_BIN_HOME:-$HOME/.local/bin}/set-wallpaper.sh"

if [[ -f "$WALLPAPER_SCRIPT" ]]; then
    sh "$WALLPAPER_SCRIPT" --current &
fi
