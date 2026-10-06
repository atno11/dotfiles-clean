#!/usr/bin/env bash
# Workspace logico: 1-6 = TOP/BOTTOM; 7-9 = tela inteira.
# Pin preserva o desktop escolhido (Tn ou Bn), sem tornar janelas sticky.
set -u

TARGET="${1:-}"
ACTION="${2:-focus}"
LAYOUT="$HOME/.config/bspwm/atno/layout.sh"
PIN_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/atno-bspwm"
PIN_FILE="$PIN_DIR/workspace-pin"

# Mantida do workspace.sh original enviado pelo usuario.
split_ready() {
    xrandr --listmonitors | awk '
        /^[[:space:]]*[0-9]+:/ {
            n++
            name=$2
            gsub(/[+*]/, "", name)
            if (name=="TOP" &&
                $3 ~ /^1080\/[0-9]+x960\/[0-9]+\+0\+0$/ &&
                $4=="HDMI-A-0") t=1
            if (name=="BOTTOM" &&
                $3 ~ /^1080\/[0-9]+x960\/[0-9]+\+0\+960$/) b=1
        }
        END {exit !(n==2 && t && b)}
    ' || return 1

    local monitor expected
    for monitor in TOP BOTTOM; do
        case "$monitor" in
            TOP) expected="0,0,1080,960" ;;
            BOTTOM) expected="0,960,1080,960" ;;
        esac
        bspc query -T -m "$monitor" | python3 -c '
import json, sys
r = json.load(sys.stdin)["rectangle"]
actual = ",".join(str(r[k]) for k in ("x", "y", "width", "height"))
sys.exit(0 if actual == sys.argv[1] else 1)
' "$expected" || return 1
    done
    bspc query -D -m BOTTOM --names | grep -Fxq B1 || return 1
    return 0
}

current_monitor() {
    bspc query -M -m focused --names 2>/dev/null || echo TOP
}

# Consulta o desktop ativo de cada monitor (nao o foco global).
active_desktop() {
    bspc query -D -d "$1:focused" --names
}

PIN_SIDE=""
PIN_DESKTOP=""
read_pin() {
    PIN_SIDE=""
    PIN_DESKTOP=""
    if [[ -f "$PIN_FILE" ]]; then
        read -r PIN_SIDE PIN_DESKTOP < "$PIN_FILE" || true
        case "$PIN_SIDE:$PIN_DESKTOP" in
            TOP:T[1-6]|BOTTOM:B[1-6]) ;;
            *) PIN_SIDE=""; PIN_DESKTOP=""; rm -f -- "$PIN_FILE" ;;
        esac
    fi
}

pin_command() {
    local command="${1^^}" desktop temp
    read_pin
    case "$command" in
        STATUS)
            if [[ -z "$PIN_SIDE" ]]; then
                echo "Pin: desligado"
            elif split_ready; then
                echo "Pin: $PIN_SIDE fixado em $PIN_DESKTOP"
            else
                echo "Pin: $PIN_SIDE/$PIN_DESKTOP suspenso no modo tela inteira"
            fi
            ;;
        OFF|CLEAR)
            rm -f -- "$PIN_FILE"
            echo "Pin: desligado"
            ;;
        TOP|BOTTOM)
            if [[ "$PIN_SIDE" == "$command" ]]; then
                rm -f -- "$PIN_FILE"
                echo "Pin: $command desfixado"
                return 0
            fi
            if ! split_ready; then
                echo "Ative primeiro um workspace dividido (1 a 6)." >&2
                return 1
            fi
            desktop="$(active_desktop "$command")" || return 1
            case "$command:$desktop" in
                TOP:T[1-6]|BOTTOM:B[1-6]) ;;
                *) echo "Nao e possivel fixar $command no desktop $desktop." >&2; return 1 ;;
            esac
            mkdir -p -- "$PIN_DIR" || return 1
            temp="$PIN_FILE.$$"
            printf '%s %s\n' "$command" "$desktop" > "$temp" || return 1
            mv -f -- "$temp" "$PIN_FILE" || return 1
            echo "Pin: $command fixado em $desktop"
            ;;
        *)
            echo "Uso: $0 pin {TOP|BOTTOM|off|status}" >&2
            return 2
            ;;
    esac
}

if [[ "$TARGET" == pin ]]; then
    pin_command "$ACTION"
    exit $?
fi

case "$TARGET" in
    1|2|3|4|5|6)
        SOURCE_MONITOR="$(current_monitor)"
        if ! split_ready; then
            "$LAYOUT" split || exit 1
        fi
        TOP_DESKTOP="T$TARGET"
        BOTTOM_DESKTOP="B$TARGET"
        read_pin
        case "$ACTION" in
            focus)
                case "$PIN_SIDE" in
                    TOP)
                        # Preserva TOP e troca apenas BOTTOM.
                        if [[ "$(active_desktop TOP)" != "$PIN_DESKTOP" ]]; then
                            bspc desktop "$PIN_DESKTOP" -a || exit 1
                        fi
                        bspc desktop "$BOTTOM_DESKTOP" -f || exit 1
                        bspc monitor BOTTOM -f
                        ;;
                    BOTTOM)
                        # Preserva BOTTOM e troca apenas TOP.
                        if [[ "$(active_desktop BOTTOM)" != "$PIN_DESKTOP" ]]; then
                            bspc desktop "$PIN_DESKTOP" -a || exit 1
                        fi
                        bspc desktop "$TOP_DESKTOP" -f || exit 1
                        bspc monitor TOP -f
                        ;;
                    *)
                        # Atalhos super+1..6 continuam trocando as duas metades.
                        bspc desktop "$TOP_DESKTOP" -f || exit 1
                        bspc desktop "$BOTTOM_DESKTOP" -f || exit 1
                        case "$SOURCE_MONITOR" in
                            BOTTOM) bspc monitor BOTTOM -f ;;
                            *) bspc monitor TOP -f ;;
                        esac
                        ;;
                esac
                ;;
            move|move-follow)
                case "$SOURCE_MONITOR" in
                    BOTTOM) destination="$BOTTOM_DESKTOP" ;;
                    *) destination="$TOP_DESKTOP" ;;
                esac
                if [[ "$ACTION" == move-follow ]]; then
                    # Uma acao explicita que troca o desktop fixado encerra o Pin.
                    [[ "$SOURCE_MONITOR" == "$PIN_SIDE" ]] && rm -f -- "$PIN_FILE"
                    bspc node -d "$destination" --follow
                else
                    bspc node -d "$destination"
                fi
                ;;
            *) echo "Acao invalida: $ACTION" >&2; exit 2 ;;
        esac
        ;;
    7|8|9)
        # O pin fica guardado e sera restaurado no retorno ao modo dividido.
        "$LAYOUT" full || exit 1
        case "$ACTION" in
            focus)
                bspc monitor TOP -f || exit 1
                bspc desktop "$TARGET" -f
                ;;
            move) bspc node -d "$TARGET" ;;
            move-follow) bspc node -d "$TARGET" --follow ;;
            *) echo "Acao invalida: $ACTION" >&2; exit 2 ;;
        esac
        ;;
    *)
        echo "Uso: $0 {1..9} [focus|move|move-follow] | pin {TOP|BOTTOM|off|status}" >&2
        exit 2
        ;;
esac
