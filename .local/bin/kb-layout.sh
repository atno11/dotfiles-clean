#!/usr/bin/env bash

COLOR="#ffffff"
LANG_MODE=false
CAPS_MODE=false
PLAIN_MODE=false
CAPS_ICON="󰪛 "

get_lang() {
    xkb-switch -p
}

get_caps() {
    xset q | awk '/Caps Lock/ {print $4}'
}

format_output() {
    local content="$1"
    local color="$2"

    if $PLAIN_MODE; then
        printf '%s' "$content"
    else
        printf '%%{F%s}%s%%{F-}' "$color" "$content"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --lang)
            LANG_MODE=true
            shift
            ;;
        --caps)
            CAPS_MODE=true
            shift
            ;;
        --color)
            COLOR="$2"
            shift 2
            ;;
        --plain)
            PLAIN_MODE=true
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            echo "Usage: $0 [--lang] [--caps] [--color COLOR] [--plain]"
            exit 1
            ;;
    esac
done

if $LANG_MODE || $CAPS_MODE; then
    output=""

    if $LANG_MODE; then
        lang="$(get_lang)"
        output+="$(format_output "$lang" "$COLOR")"
    fi

    if $CAPS_MODE; then
        caps="$(get_caps)"

        if [[ "$caps" == "on" ]]; then
            [[ -n "$output" ]] && output+=" "
            output+="$(format_output "$CAPS_ICON" "$COLOR")"
        fi
    fi

    printf '%s' "$output"
else
    lang="$(get_lang)"
    caps="$(get_caps)"

    if [[ "$caps" == "on" ]]; then
        format_output "$lang | $CAPS_ICON" "$COLOR"
    else
        format_output "$lang" "$COLOR"
    fi

    printf '\n'
fi
