#!/usr/bin/env bash

set -u

FG="cdd6f4"
WRONG="f38ba8"
ACCENT="b4befe"

WALLPAPER_LINK="${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers/.current.wall"

lock_screen() {
    local args=(
        -n
        --force-clock
        -e

        --indicator
        --radius=120
        --ring-width=8

        --inside-color="${FG}22"
        --ring-color="$ACCENT"

        --insidever-color="${ACCENT}33"
        --ringver-color="$ACCENT"

        --insidewrong-color="${WRONG}33"
        --ringwrong-color="$WRONG"

        --line-uses-inside
        --keyhl-color="$ACCENT"
        --separator-color="$ACCENT"
        --bshl-color="$WRONG"

        --time-str="%H:%M"
        --date-str="%a, %d %b %Y"

        --verif-text="Verifying..."
        --wrong-text="Wrong password"
        --noinput-text=""
        --greeter-text="Type your password to unlock"

        --time-font="JetBrainsMono Nerd Font"
        --date-font="JetBrainsMono Nerd Font"
        --verif-font="JetBrainsMono Nerd Font"
        --greeter-font="JetBrainsMono Nerd Font"
        --wrong-font="JetBrainsMono Nerd Font"

        --time-color="$ACCENT"
        --date-color="$ACCENT"
        --greeter-color="$FG"
        --wrong-color="$WRONG"
        --verif-color="$ACCENT"

        --pointer=default

        --pass-media-keys
        --pass-volume-keys
    )

    if [[ -L "$WALLPAPER_LINK" ]]; then
        local wallpaper

        wallpaper="$(readlink -f "$WALLPAPER_LINK" 2>/dev/null || true)"

        if [[ -f "$wallpaper" ]]; then
            args+=(-i "$wallpaper")
        fi
    fi

    i3lock "${args[@]}"
}

case "${1:-}" in
    --suspend)
        lock_screen &
        lock_pid=$!

        sleep 0.5

        if kill -0 "$lock_pid" 2>/dev/null; then
            systemctl suspend
        fi

        wait "$lock_pid"
        ;;

    "")
        lock_screen
        ;;

    *)
        echo "Usage: $0 [--suspend]" >&2
        exit 1
        ;;
esac
