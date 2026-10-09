#!/usr/bin/env bash

set -euo pipefail

SXHKD_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/sxhkd/sxhkdrc"
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/keyhints.rasi"

usage() {
    printf 'Usage: %s [--list|--count|--help]\n' "$0"
}

generate_hints() {
    awk '
        function emit() {
            if (key != "" && description != "") {
                printf "%s\t%s\n", key, description
            }

            key = ""
            description = ""
        }

        /^[[:space:]]*#[[:space:]]*Description:/ {
            emit()
            description = $0
            sub(/^[[:space:]]*#[[:space:]]*Description:[[:space:]]*/, "", description)
            next
        }

        /^[[:space:]]*#/ || /^[[:space:]]*$/ {
            next
        }

        /^[^[:space:]#]/ {
            if (key != "") {
                emit()
            }

            key = $0
            next
        }

        END {
            emit()
        }
    ' "$SXHKD_CONFIG"
}

escape_markup() {
    local value="$1"

    value="${value//&/&amp;}"
    value="${value//</&lt;}"
    value="${value//>/&gt;}"

    printf '%s' "$value"
}

generate_cards() {
    local key description

    while IFS=$'\t' read -r key description; do
        [[ -n "$key" && -n "$description" ]] || continue

        key="$(escape_markup "$key")"
        description="$(escape_markup "$description")"

        printf '<span weight="bold">%s</span>  <span size="small">%s</span>\n' \
            "$key" "$description"
    done
}

case "${1:-}" in
    --help|-h)
        usage
        exit 0
        ;;
    --list|--count|"")
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac

if [[ ! -r "$SXHKD_CONFIG" ]]; then
    printf 'ERROR: sxhkd configuration is not readable: %s\n' \
        "$SXHKD_CONFIG" >&2
    exit 1
fi

HINTS="$(generate_hints)"

if [[ -z "$HINTS" ]]; then
    printf 'ERROR: no described shortcuts found.\n' >&2
    exit 1
fi

case "${1:-}" in
    --list)
        printf '%s\n' "$HINTS" | tr '\t' ' '
        exit 0
        ;;
    --count)
        printf '%s\n' "$HINTS" | wc -l
        exit 0
        ;;
esac

if ! command -v rofi >/dev/null 2>&1; then
    printf 'ERROR: rofi is not installed.\n' >&2
    exit 1
fi

ROFI_THEME_OVERRIDE='
window {
    width: 90%;
}

mainbox {
    children: [inputbar, listview];
    spacing: 12px;
}

inputbar {
    children: [prompt, entry];
    spacing: 10px;
    padding: 10px;
}

listview {
    columns: 2;
    lines: 6;
    layout: vertical;
    flow: horizontal;
    fixed-columns: true;
    fixed-height: true;
    dynamic: false;
    spacing: 12px;
    scrollbar: true;
}

element {
    orientation: horizontal;
    children: [element-text];
    padding: 18px;
    border: 1px;
    border-radius: 10px;
}

element-text {
    horizontal-align: 0.0;
    vertical-align: 0.5;
}
'

# Read-only UI: selecting an item never executes anything.
set +e

printf '%s\n' "$HINTS" |
    generate_cards |
    rofi \
        -dmenu \
        -markup-rows \
        -i \
        -no-custom \
        -p "Keyhints" \
        -mesg "Shortcut reference | Esc to close" \
        -no-config \
-theme "$ROFI_THEME" \
        >/dev/null

status=$?

set -e

if (( status == 1 )); then
    exit 0
fi

exit "$status"
