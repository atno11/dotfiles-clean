#!/usr/bin/env bash

ACTION="${1:-toggle}"

case "$ACTION" in
    --start)
        ACTION="start"
        ;;
    --stop)
        ACTION="stop"
        ;;
    toggle|"")
        ACTION="toggle"
        ;;
    *)
        echo "Usage: $0 [--start|--stop]" >&2
        exit 1
        ;;
esac

start_bar() {
    if pgrep -x polybar >/dev/null 2>&1; then
        return 0
    fi

    if [[ ! -x "$HOME/.config/polybar/launch.sh" ]]; then
        echo "Polybar launcher not found." >&2
        return 1
    fi

    "$HOME/.config/polybar/launch.sh"

    bspc config -m focused top_padding 31
}

stop_bar() {
    if pgrep -x polybar >/dev/null 2>&1; then
        killall polybar
    fi

    bspc config -m focused top_padding 0
}

case "$ACTION" in
    start)
        start_bar
        ;;

    stop)
        stop_bar
        ;;

    toggle)
        if pgrep -x polybar >/dev/null 2>&1; then
            stop_bar
        else
            start_bar
        fi
        ;;
esac
