#!/usr/bin/env bash

if ! command -v clipnotify >/dev/null 2>&1 ||
   ! command -v xclip >/dev/null 2>&1 ||
   ! command -v cliphist >/dev/null 2>&1
then
    return 0
fi

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_FILE="$RUNTIME_DIR/atno-bspwm-clipboard-${UID}.lock"

(
    exec 9>"$LOCK_FILE"

    flock -n 9 || exit 0

    while clipnotify; do
        clipboard="$(
            xclip \
                -o \
                -selection clipboard \
                2>/dev/null
        )"

        [[ -n "$clipboard" ]] || continue

        printf '%s' "$clipboard" |
            cliphist store
    done
) &
