#!/usr/bin/env bash
set -uo pipefail

DIR="$HOME/.config/bspwm/atno"
LAYOUT="$DIR/layout.sh"

mkdir -p "$DIR/.tmp"

# Impede que duas instâncias executem simultaneamente.
exec 9>"$DIR/.tmp/monitor-watch.lock"
flock -n 9 || exit 0

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$*"
}

# Verifica conexão HDMI e estado DPMS.
monitor_ready() {
    local randr dpms

    randr="$(xrandr --query 2>/dev/null)" || return 1

    grep -Eq '^HDMI-A-0 connected([[:space:]]|$)' \
        <<< "$randr" || return 1

    dpms="$(xset q 2>/dev/null || true)"

    case "$dpms" in
        *"Monitor is Off"*|*"Monitor is in Standby"*|*"Monitor is in Suspend"*)
            return 1
            ;;
    esac

    return 0
}

last_mode=""
last_top=""
last_bottom=""
last_focus=""

# Salva os desktops ativos antes de a tela desligar.
save_state() {
    local top bottom focus

    top="$(bspc query -D -d TOP:focused --names 2>/dev/null || true)"
    bottom="$(bspc query -D -d BOTTOM:focused --names 2>/dev/null || true)"
    focus="$(bspc query -M -m focused --names 2>/dev/null || true)"

    case "$top" in
        T[1-6]) last_mode="split" ;;
        7|8|9)  last_mode="full" ;;
    esac

    [[ -n "$top" ]] && last_top="$top"
    [[ -n "$bottom" ]] && last_bottom="$bottom"
    [[ -n "$focus" ]] && last_focus="$focus"
}

restore_focus() {
    if [[ "$last_mode" == split ]]; then
        [[ "$last_top" == T[1-6] ]] &&
            bspc desktop "$last_top" -f

        [[ "$last_bottom" == B[1-6] ]] &&
            bspc desktop "$last_bottom" -f

        if [[ "$last_focus" == BOTTOM ]]; then
            bspc monitor BOTTOM -f
        else
            bspc monitor TOP -f
        fi
    else
        case "$last_top" in
            7|8|9) bspc desktop "$last_top" -f ;;
        esac

        bspc monitor TOP -f
    fi
}

save_state

was_off=0
monitor_ready || was_off=1

log "Monitoramento iniciado. Modo: ${last_mode:-desconhecido}"

while sleep 1; do
    if ! monitor_ready; then
        if (( !was_off )); then
            log "Monitor desligado ou desconectado"
        fi

        was_off=1
        continue
    fi

    # Enquanto a tela funciona, atualiza o desktop atual.
    if (( !was_off )); then
        save_state
        continue
    fi

    # Aguarda a conexão estabilizar.
    sleep 2
    monitor_ready || continue

    if [[ "$last_mode" != split && "$last_mode" != full ]]; then
        save_state
    fi

    log "Monitor reconectado. Recuperando: ${last_mode:-desconhecido}"

    case "$last_mode" in
        split)
            "$LAYOUT" full && "$LAYOUT" split
            result=$?
            ;;
        full)
            "$LAYOUT" split && "$LAYOUT" full
            result=$?
            ;;
        *)
            log "Não foi possível identificar o modo anterior"
            sleep 2
            continue
            ;;
    esac

    if (( result == 0 )); then
        restore_focus
        was_off=0
        save_state
        log "Layout recuperado: $last_mode"
    else
        log "Falha na recuperação; nova tentativa em breve"
        sleep 2
    fi
done
