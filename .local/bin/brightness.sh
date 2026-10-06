#!/usr/bin/env bash

DEFAULT_COLOR="#61afef"

get_backlight_device() {
    local device

    device="$(
        find /sys/class/backlight \
            -mindepth 1 \
            -maxdepth 1 \
            -printf '%f\n' \
            2>/dev/null |
            head -n 1
    )"

    [[ -n "$device" ]] || return 1

    printf '%s\n' "$device"
}

get_brightness() {
    brightnessctl \
        -d "$1" \
        -m |
        cut -d, -f4
}

brightness_icon() {
    local value="$1"
    local color="$2"
    local icon

    case "$value" in
        100%)   icon="" ;;
        9[0-9]%) icon="" ;;
        8[0-9]%) icon="" ;;
        7[0-9]%) icon="" ;;
        6[0-9]%) icon="" ;;
        5[1-9]%) icon="" ;;
        50%)     icon="" ;;
        4[0-9]%) icon="" ;;
        3[0-9]%) icon="" ;;
        2[0-9]%) icon="" ;;
        1[0-9]%) icon="" ;;
        [1-9]%)  icon="" ;;
        0%)      icon="" ;;
        *)       icon="" ;;
    esac

    printf '%%{F%s}%s %s%%{F-}\n' \
        "$color" \
        "$icon" \
        "$value"
}

BRIGHTNESS_DEVICE="$(get_backlight_device || true)"

if [[ -z "$BRIGHTNESS_DEVICE" ]]; then
    # Máquina sem backlight, como desktop.
    exit 0
fi

STATUS_MODE=false

while (( $# > 0 )); do
    case "$1" in
        --status)
            STATUS_MODE=true
            ;;

        --color)
            [[ $# -ge 2 ]] || {
                echo "Missing value for --color" >&2
                exit 1
            }

            DEFAULT_COLOR="$2"
            shift
            ;;

        --up)
            brightnessctl \
                -d "$BRIGHTNESS_DEVICE" \
                set +5%
            exit
            ;;

        --down)
            brightnessctl \
                -d "$BRIGHTNESS_DEVICE" \
                set 5%-
            exit
            ;;

        --max)
            brightnessctl \
                -d "$BRIGHTNESS_DEVICE" \
                set 100%
            exit
            ;;

        --min)
            brightnessctl \
                -d "$BRIGHTNESS_DEVICE" \
                set 0%
            exit
            ;;

        *)
            echo \
                "Usage: $0 [--status] [--color COLOR] [--up|--down|--max|--min]" \
                >&2
            exit 1
            ;;
    esac

    shift
done

if $STATUS_MODE; then
    BRIGHTNESS_VALUE="$(
        get_brightness "$BRIGHTNESS_DEVICE"
    )"

    brightness_icon \
        "$BRIGHTNESS_VALUE" \
        "$DEFAULT_COLOR"
fi
