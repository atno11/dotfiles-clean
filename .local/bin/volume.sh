#!/usr/bin/env bash

ENABLED_COLOR="#A3BE8C"
DISABLED_COLOR="#D35F5E"

DEVICE=""
ACTION=""
STATUS=false
PAMIXER_ARGS=()


print_error() {
    echo \
        "Usage: $0 --device <input|output> [--action <increase|decrease|toggle>] [--status] [--enabled-color COLOR] [--disabled-color COLOR]" \
        >&2

    exit 1
}


pamixer_cmd() {
    pamixer \
        "${PAMIXER_ARGS[@]}" \
        "$@"
}


get_volume() {
    pamixer_cmd --get-volume
}


is_muted() {
    [[ "$(pamixer_cmd --get-mute)" == "true" ]]
}


notify_volume() {
    local volume

    volume="$(get_volume)"

    notify-send \
        -u low \
        "Volume" \
        "${volume}%"
}


notify_mute() {
    if is_muted; then
        notify-send \
            -u low \
            "Muted"
    else
        notify-send \
            -u low \
            "Unmuted"
    fi
}


print_status() {
    local volume
    local icon
    local color

    volume="$(get_volume)"

    if [[ "$DEVICE" == "output" ]]; then
        if is_muted; then
            icon="  $volume%"
            color="$DISABLED_COLOR"
        elif (( volume <= 30 )); then
            icon=" $volume%"
            color="$ENABLED_COLOR"
        elif (( volume <= 60 )); then
            icon=" $volume%"
            color="$ENABLED_COLOR"
        else
            icon="  $volume%"
            color="$ENABLED_COLOR"
        fi
    else
        if is_muted; then
            icon="  $volume%"
            color="$DISABLED_COLOR"
        else
            icon=" $volume%"
            color="$ENABLED_COLOR"
        fi
    fi

    printf '%%{F%s}%s%%{F-}\n' \
        "$color" \
        "$icon"
}


change_volume() {
    case "$ACTION" in
        increase)
            pamixer_cmd -i 2
            notify_volume
            ;;

        decrease)
            pamixer_cmd -d 2
            notify_volume
            ;;

        toggle)
            pamixer_cmd -t
            notify_mute
            ;;

        *)
            print_error
            ;;
    esac
}


while (( $# > 0 )); do
    case "$1" in
        --device)
            [[ $# -ge 2 ]] || print_error
            DEVICE="$2"
            shift
            ;;

        --action)
            [[ $# -ge 2 ]] || print_error
            ACTION="$2"
            shift
            ;;

        --enabled-color)
            [[ $# -ge 2 ]] || print_error
            ENABLED_COLOR="$2"
            shift
            ;;

        --disabled-color)
            [[ $# -ge 2 ]] || print_error
            DISABLED_COLOR="$2"
            shift
            ;;

        --status)
            STATUS=true
            ;;

        *)
            print_error
            ;;
    esac

    shift
done


case "$DEVICE" in
    input)
        PAMIXER_ARGS=(
            --default-source
        )
        ;;

    output)
        PAMIXER_ARGS=()
        ;;

    *)
        print_error
        ;;
esac


if $STATUS; then
    print_status
    exit
fi

[[ -n "$ACTION" ]] || print_error

change_volume
