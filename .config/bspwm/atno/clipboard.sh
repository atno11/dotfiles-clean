#!/usr/bin/env bash

# Clipboard monitor for bspwm/X11.
# Preserve text history and normalize BMP-only images to PNG.

if ! command -v clipnotify >/dev/null 2>&1 ||
   ! command -v xclip >/dev/null 2>&1 ||
   ! command -v cliphist >/dev/null 2>&1
then
    return 0 2>/dev/null || exit 0
fi

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_FILE="$RUNTIME_DIR/atno-bspwm-clipboard-${UID}.lock"

(
    exec 9>"$LOCK_FILE"
    flock -n 9 || exit 0

    clipboard_targets() {
        xclip -selection clipboard -t TARGETS -o 2>/dev/null
    }

    has_target() {
        grep -Fxq -- "$1" <<< "$2"
    }

    convert_bmp_to_png() {
        command -v magick >/dev/null 2>&1 || return 1

        local targets="$1"
        local current_targets
        local temp_dir
        local bmp_file
        local png_file

        has_target "image/bmp" "$targets" || return 1
        has_target "image/png" "$targets" && return 1

        temp_dir="$(mktemp -d "$RUNTIME_DIR/deskflow-bmp.XXXXXXXX")" ||
            return 1

        bmp_file="$temp_dir/image.bmp"
        png_file="$temp_dir/image.png"

        if ! xclip -selection clipboard -t image/bmp -o \
            > "$bmp_file" 2>/dev/null; then
            rm -rf -- "$temp_dir"
            return 1
        fi

        # Reject empty or unusually large clipboard payloads.
        local bmp_size
        bmp_size="$(stat -c '%s' "$bmp_file")"

        if (( bmp_size < 54 || bmp_size > 67108864 )); then
            rm -rf -- "$temp_dir"
            return 1
        fi

        if ! magick "$bmp_file" "PNG:$png_file" 2>/dev/null ||
           [[ ! -s "$png_file" ]]; then
            rm -rf -- "$temp_dir"
            return 1
        fi

        # Avoid replacing a newer clipboard entry with an old image.
        current_targets="$(clipboard_targets)"

        if [[ "$current_targets" != "$targets" ]] ||
           ! xclip -selection clipboard -t image/bmp -o \
                2>/dev/null | cmp -s - "$bmp_file"; then
            rm -rf -- "$temp_dir"
            return 1
        fi

        xclip -selection clipboard -t image/png -i "$png_file"
        local result=$?

        rm -rf -- "$temp_dir"
        return "$result"
    }

    store_text_history() {
        local clipboard

        clipboard="$(
            xclip -o -selection clipboard 2>/dev/null
        )"

        [[ -n "$clipboard" ]] || return 0

        printf '%s' "$clipboard" | cliphist store
    }

    while clipnotify; do
        targets="$(clipboard_targets)"
        [[ -n "$targets" ]] || continue

        if has_target "image/bmp" "$targets" &&
           ! has_target "image/png" "$targets"; then
            convert_bmp_to_png "$targets"
            continue
        fi

        # Do not send binary image payloads to the text history.
        if has_target "image/png" "$targets" ||
           has_target "image/bmp" "$targets"; then
            continue
        fi

        store_text_history
    done
) &
