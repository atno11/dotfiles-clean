#!/usr/bin/env bash

get_workspace() {
    local top bottom full

    # Modo FULL: 7, 8 ou 9
    if bspc query -M --names 2>/dev/null | grep -qx "FULL"; then
        full="$(bspc query -D -m FULL -d focused --names 2>/dev/null)"

        case "$full" in
            7|8|9)
                echo "$full"
                return
                ;;
        esac
    fi

    # Modo dividido.
    # Tn e Bn representam juntos o mesmo workspace lógico.
    top="$(bspc query -D -m TOP -d focused --names 2>/dev/null)"
    bottom="$(bspc query -D -m BOTTOM -d focused --names 2>/dev/null)"

    case "$top" in
        T[1-6])
            echo "${top#T}"
            return
            ;;
    esac

    case "$bottom" in
        B[1-6])
            echo "${bottom#B}"
            return
            ;;
    esac

    echo "1"
}

render() {
    local current
    current="$(get_workspace)"

    for i in {1..9}; do
        if [[ "$i" == "$current" ]]; then
            printf '%%{A1:%s/.config/bspwm/atno/workspace.sh %s:}' "$HOME" "$i"
            printf '%%{F#cdd6f4}%%{B#1e1e2e}  %s  %%{B-}%%{F-}' "$i"
            printf '%%{A}'
        else
            printf '%%{A1:%s/.config/bspwm/atno/workspace.sh %s:}' "$HOME" "$i"
            printf '  %s  ' "$i"
            printf '%%{A}'
        fi
    done

    printf '\n'
}

render

bspc subscribe \
    desktop_focus \
    desktop_activate \
    desktop_transfer \
    monitor_focus \
    monitor_add \
    monitor_remove 2>/dev/null |
while read -r _; do
    render
done
