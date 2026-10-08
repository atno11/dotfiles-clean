#!/usr/bin/env bash
# Prepare per-user TLS identity and trust before enabling the Deskflow services.
set -Eeuo pipefail
umask 077

USER_DIR="$HOME/.config/Deskflow"
USER_TLS="$USER_DIR/tls"
SDDM_DIR="/var/lib/sddm/.config/Deskflow"
SDDM_TLS="$SDDM_DIR/tls"
TEMP_DIR=""

usage() {
    cat <<'USAGE'
Usage:
  ./scripts/setup-deskflow.sh prepare <windows-ip-or-host> <windows-sha256-fingerprint>
  ./scripts/setup-deskflow.sh activate

Prepare preserves existing certificates and settings, creates identities if needed,
and registers the Windows certificate fingerprint in both Arch trust databases.
Add BOTH Arch fingerprints to the Windows trusted-clients file and enable Windows
TLS and client certificate checking before running activate.
USAGE
}

fatal() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
cleanup() { [[ -z "$TEMP_DIR" ]] || rm -rf -- "$TEMP_DIR"; }
trap cleanup EXIT

need_tools() {
    for cmd in python3 openssl sudo; do
        command -v "$cmd" >/dev/null 2>&1 || fatal "Missing command: $cmd"
    done
}

# Preserve existing sections and settings, replacing only the requested keys.
patch_config() {
    local file="$1" mode="$2" server="${3:-}" cert="${4:-}"
    python3 - "$file" "$mode" "$server" "$cert" <<'PY'
from pathlib import Path
import re
import sys

path, mode, server, cert = Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4]
lines = path.read_text().splitlines() if path.exists() else []

def put(section, key, value):
    header = f"[{section}]"
    try:
        begin = next(i for i, line in enumerate(lines) if line.strip() == header)
    except StopIteration:
        if lines and lines[-1] != "":
            lines.append("")
        lines.extend([header, f"{key}={value}"])
        return
    end = next((i for i in range(begin + 1, len(lines)) if re.match(r'^\s*\[[^\]]+\]\s*$', lines[i])), len(lines))
    positions = [i for i in range(begin + 1, end)
                 if re.match(r'^\s*' + re.escape(key) + r'\s*=', lines[i])]
    if positions:
        lines[positions[0]] = f"{key}={value}"
        for i in reversed(positions[1:]):
            del lines[i]
    else:
        lines.insert(end, f"{key}={value}")

def has(section, key):
    active = False
    for line in lines:
        if re.match(r'^\s*\[[^\]]+\]\s*$', line):
            active = line.strip() == f"[{section}]"
        elif active and re.match(r'^\s*' + re.escape(key) + r'\s*=', line):
            return True
    return False

if mode == 'prepare':
    put('client', 'remoteHost', server)
    put('core', 'coreMode', '1')
    put('core', 'processMode', '1')
    put('security', 'certificate', cert)
    put('security', 'checkPeerFingerprints', 'true')
    put('security', 'keySize', '2048')
    if not has('security', 'tlsEnabled'):
        put('security', 'tlsEnabled', 'false')
elif mode == 'activate':
    put('security', 'tlsEnabled', 'true')
else:
    raise SystemExit('Unknown mode')
path.write_text('\n'.join(lines).rstrip('\n') + '\n')
PY
}

make_cert() {
    local cert="$1" owner="$2"
    if [[ -e "$cert" ]]; then
        [[ -s "$cert" ]] || fatal "Empty certificate: $cert"
        if [[ "$owner" == sddm ]]; then
            sudo openssl x509 -in "$cert" -noout >/dev/null || fatal "Invalid certificate: $cert"
        else
            openssl x509 -in "$cert" -noout >/dev/null || fatal "Invalid certificate: $cert"
        fi
        return
    fi

    local output="$TEMP_DIR/cert-$owner.pem"
    local key="$TEMP_DIR/key-$owner.pem" crt="$TEMP_DIR/crt-$owner.pem"
    openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 365 \
        -subj /CN=Deskflow -keyout "$key" -out "$crt" >/dev/null 2>&1
    cat "$key" "$crt" > "$output"
    if [[ "$owner" == sddm ]]; then
        sudo install -o sddm -g sddm -m 600 "$output" "$cert"
    else
        install -m 600 "$output" "$cert"
    fi
}

add_trusted_server() {
    local dest="$1" fp="$2" owner="$3"
    local temp="$TEMP_DIR/trust-$owner"
    if [[ "$owner" == sddm ]]; then
        if sudo test -f "$dest"; then sudo cat "$dest" > "$temp"; else : > "$temp"; fi
    else
        if [[ -f "$dest" ]]; then cat "$dest" > "$temp"; else : > "$temp"; fi
    fi
    if ! grep -Fxq "v2:sha256:$fp" "$temp"; then
        printf 'v2:sha256:%s\n' "$fp" >> "$temp"
    fi
    if [[ "$owner" == sddm ]]; then
        sudo install -o sddm -g sddm -m 600 "$temp" "$dest"
    else
        install -m 600 "$temp" "$dest"
    fi
}

prepare() {
    [[ $# -eq 2 ]] || { usage; exit 2; }
    local server="$1" fingerprint
    fingerprint="$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]' | tr -d ':')"
    [[ "$server" =~ ^[a-zA-Z0-9._-]+$ ]] || fatal 'Invalid server name or address'
    [[ "$fingerprint" =~ ^[0-9a-f]{64}$ ]] || fatal 'Server fingerprint must be 64 hex characters (SHA-256)'

    mkdir -p "$USER_TLS"
    chmod 700 "$USER_TLS"
    sudo install -d -o sddm -g sddm -m 700 "$SDDM_TLS"

    make_cert "$USER_TLS/deskflow.pem" "$USER"
    make_cert "$SDDM_TLS/deskflow.pem" sddm
    chmod 600 "$USER_TLS/deskflow.pem"
    sudo chmod 600 "$SDDM_TLS/deskflow.pem"

    add_trusted_server "$USER_TLS/trusted-servers" "$fingerprint" "$USER"
    add_trusted_server "$SDDM_TLS/trusted-servers" "$fingerprint" sddm

    local user_conf="$TEMP_DIR/user.conf" sddm_conf="$TEMP_DIR/sddm.conf"
    if [[ -f "$USER_DIR/Deskflow.conf" ]]; then
        cat "$USER_DIR/Deskflow.conf" > "$user_conf"
    else
        : > "$user_conf"
    fi
    if sudo test -f "$SDDM_DIR/Deskflow.conf"; then
        sudo cat "$SDDM_DIR/Deskflow.conf" > "$sddm_conf"
    else
        : > "$sddm_conf"
    fi
    patch_config "$user_conf" prepare "$server" "$USER_TLS/deskflow.pem"
    patch_config "$sddm_conf" prepare "$server" "$SDDM_TLS/deskflow.pem"
    install -m 600 "$user_conf" "$USER_DIR/Deskflow.conf"
    sudo install -o sddm -g sddm -m 600 "$sddm_conf" "$SDDM_DIR/Deskflow.conf"

    printf '\nWindows Deskflow must trust BOTH Arch client fingerprints:\n'
    printf 'BSPWM: '; openssl x509 -in "$USER_TLS/deskflow.pem" -noout -fingerprint -sha256
    printf 'SDDM:  '; sudo openssl x509 -in "$SDDM_TLS/deskflow.pem" -noout -fingerprint -sha256
    printf '\nPlace their v2:sha256:<lowercase hash without colons> entries in:\n'
    printf '  C:\\ProgramData\\Deskflow\\tls\\trusted-clients\n'
    printf 'Enable TLS and Require client certificates on Windows, then run:\n'
    printf '  ./scripts/setup-deskflow.sh activate\n'
    printf 'No Deskflow services were restarted or enabled.\n'
}

activate() {
    [[ $# -eq 0 ]] || { usage; exit 2; }
    for f in "$USER_DIR/Deskflow.conf" "$USER_TLS/deskflow.pem" "$USER_TLS/trusted-servers"; do
        [[ -s "$f" ]] || fatal "Missing or empty: $f (run prepare first)"
    done
    for f in "$SDDM_DIR/Deskflow.conf" "$SDDM_TLS/deskflow.pem" "$SDDM_TLS/trusted-servers"; do
        sudo test -s "$f" || fatal "Missing or empty: $f (run prepare first)"
    done
    [[ -f /etc/systemd/system/deskflow-sddm.service ]] || fatal 'System service missing; install dotfiles first'
    [[ -f "$HOME/.config/systemd/user/deskflow-client.service" ]] || fatal 'User service missing; install dotfiles first'

    printf 'Windows must have TLS enabled, require client certificates,\n'
    printf 'and trust both Arch client fingerprints. This restarts the client.\n'
    local answer
    read -r -p "Type ATIVAR to proceed: " answer
    [[ "$answer" == ATIVAR ]] || fatal 'Canceled without changes'

    local user_conf="$TEMP_DIR/user.conf" sddm_conf="$TEMP_DIR/sddm.conf"
    cat "$USER_DIR/Deskflow.conf" > "$user_conf"
    sudo cat "$SDDM_DIR/Deskflow.conf" > "$sddm_conf"
    patch_config "$user_conf" activate
    patch_config "$sddm_conf" activate
    install -m 600 "$user_conf" "$USER_DIR/Deskflow.conf"
    sudo install -o sddm -g sddm -m 600 "$sddm_conf" "$SDDM_DIR/Deskflow.conf"

    sudo systemctl daemon-reload
    sudo systemctl enable --now deskflow-sddm.service
    systemctl --user daemon-reload
    if [[ -n "${DISPLAY:-}" && -n "${XAUTHORITY:-}" ]]; then
        systemctl --user import-environment DISPLAY XAUTHORITY
        systemctl --user restart deskflow-client.service
    else
        printf 'No active X11 login; user client starts on next BSPWM login.\n'
    fi
    printf 'TLS activated. Check TLS logs and test SDDM before rebooting.\n'
}

[[ "$EUID" -ne 0 ]] || fatal 'Run as the desktop user, not root'
need_tools
TEMP_DIR="$(mktemp -d)"
case "${1:-}" in
    prepare) shift; prepare "$@" ;;
    activate) shift; activate "$@" ;;
    *) usage; exit 2 ;;
esac
