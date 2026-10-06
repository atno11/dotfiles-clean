#!/usr/bin/env bash

set -o pipefail

selection="$(
    cliphist list |
        rofi \
            -dmenu \
            -display-columns 2
)"

[[ -n "$selection" ]] || exit 0

printf '%s\n' "$selection" |
    cliphist decode |
    xclip \
        -selection clipboard
