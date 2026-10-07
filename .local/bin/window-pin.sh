#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/bspwm-window-pin-${USER}"

mkdir -p "$STATE_DIR"

win_id="$(bspc query -N -n focused 2>/dev/null)" || exit 0
[[ -n "$win_id" ]] || exit 0

state_file="$STATE_DIR/${win_id}.state"

is_sticky="$(bspc query -N -n "$win_id.sticky" 2>/dev/null || true)"
is_locked="$(bspc query -N -n "$win_id.locked" 2>/dev/null || true)"

restore_window() {
    [[ -f "$state_file" ]] || return 1

    # shellcheck disable=SC1090
    source "$state_file"

    bspc node "$win_id" -g sticky=off
    bspc node "$win_id" -g locked=off

    if [[ -n "${ORIGINAL_DESKTOP:-}" ]]; then
        bspc node "$win_id" -d "$ORIGINAL_DESKTOP"
    fi

    case "${ORIGINAL_STATE:-tiled}" in
        floating)
            bspc node "$win_id" -t floating

            if command -v xdotool >/dev/null 2>&1; then
                xdotool windowmove \
                    "$win_id" \
                    "${ORIGINAL_X:-0}" \
                    "${ORIGINAL_Y:-0}"

                xdotool windowsize \
                    "$win_id" \
                    "${ORIGINAL_WIDTH:-800}" \
                    "${ORIGINAL_HEIGHT:-600}"
            fi
            ;;

        pseudo_tiled)
            bspc node "$win_id" -t pseudo_tiled
            ;;

        fullscreen)
            bspc node "$win_id" -t fullscreen
            ;;

        *)
            bspc node "$win_id" -t tiled
            ;;
    esac

    rm -f "$state_file"

    bspc node "$win_id" -f
}

save_window_state() {
    local node_json
    local original_state
    local original_desktop

    local x=""
    local y=""
    local width=""
    local height=""

    node_json="$(bspc query -T -n "$win_id" 2>/dev/null)" || return 1

    original_state="$(
        printf '%s\n' "$node_json" |
            jq -r '.client.state // "tiled"'
    )"

    original_desktop="$(
        bspc query -D -d focused --names 2>/dev/null |
            head -n 1
    )"

    if [[ "$original_state" == "floating" ]] &&
        command -v xdotool >/dev/null 2>&1; then

        eval "$(
            xdotool getwindowgeometry --shell "$win_id" 2>/dev/null |
                sed \
                    -e 's/^X=/ORIGINAL_X=/' \
                    -e 's/^Y=/ORIGINAL_Y=/' \
                    -e 's/^WIDTH=/ORIGINAL_WIDTH=/' \
                    -e 's/^HEIGHT=/ORIGINAL_HEIGHT=/'
        )"

        x="${ORIGINAL_X:-}"
        y="${ORIGINAL_Y:-}"
        width="${ORIGINAL_WIDTH:-}"
        height="${ORIGINAL_HEIGHT:-}"
    fi

    {
        printf 'ORIGINAL_STATE=%q\n' "$original_state"
        printf 'ORIGINAL_DESKTOP=%q\n' "$original_desktop"
        printf 'ORIGINAL_X=%q\n' "$x"
        printf 'ORIGINAL_Y=%q\n' "$y"
        printf 'ORIGINAL_WIDTH=%q\n' "$width"
        printf 'ORIGINAL_HEIGHT=%q\n' "$height"
    } > "$state_file"
}

if [[ -n "$is_sticky" && -n "$is_locked" ]]; then
    restore_window
    exit $?
fi

save_window_state || exit 1

if ! bspc query -N -n "$win_id.floating" >/dev/null 2>&1; then
    bspc node "$win_id" -t floating
fi

bspc node "$win_id" -g sticky=on
bspc node "$win_id" -g locked=on
bspc node "$win_id" -f
