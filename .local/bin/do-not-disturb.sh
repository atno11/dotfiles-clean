#!/usr/bin/env bash

ENABLED_COLOR="#A3BE8C"
DISABLED_COLOR="#d35f5e"
SHOW_STATUS=false

dunst_available() {
    command -v dunstctl >/dev/null 2>&1 &&
        pgrep -x dunst >/dev/null 2>&1
}

get_paused_state() {
    if ! dunst_available; then
        echo "false"
        return
    fi

    dunstctl is-paused
}

toggle_notifications() {
    if ! dunst_available; then
        notify-send "Do Not Disturb" "Dunst is not running."
        return 1
    fi

    if [[ "$(get_paused_state)" == "true" ]]; then
        dunstctl set-paused false
        notify-send "Do Not Disturb: OFF"
    else
        notify-send "Do Not Disturb: ON"
        dunstctl set-paused true
    fi
}

print_status() {
    local icon
    local color

    if [[ "$(get_paused_state)" == "true" ]]; then
        icon="󱏧 "
        color="$DISABLED_COLOR"
    else
        icon="󱅫 "
        color="$ENABLED_COLOR"
    fi

    printf '%%{F%s}%s%%{F-}\n' "$color" "$icon"
}

while (( $# > 0 )); do
    case "$1" in
        --status)
            SHOW_STATUS=true
            ;;

        --enabled-color)
            [[ $# -ge 2 ]] || exit 1
            ENABLED_COLOR="$2"
            shift
            ;;

        --disabled-color)
            [[ $# -ge 2 ]] || exit 1
            DISABLED_COLOR="$2"
            shift
            ;;

        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac

    shift
done

if $SHOW_STATUS; then
    print_status
else
    toggle_notifications
fi
