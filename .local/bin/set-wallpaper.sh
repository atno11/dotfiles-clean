#!/usr/bin/env bash

set -u

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
WALLPAPERS_DIR="$DATA_HOME/wallpapers"
CURRENT_WALL_LINK="$WALLPAPERS_DIR/.current.wall"

mkdir -p "$WALLPAPERS_DIR" || {
    echo "Failed to create wallpapers directory: $WALLPAPERS_DIR" >&2
    exit 1
}

update_wallpaper_link() {
    local target_wallpaper

    target_wallpaper="$(realpath "$1")" || return 1

    ln -sfn "$target_wallpaper" "$CURRENT_WALL_LINK" || {
        echo "Failed to create wallpaper symlink." >&2
        return 1
    }
}

apply_wallpaper() {
    local wallpaper="$1"

    if ! command -v feh >/dev/null 2>&1; then
        echo "feh is required to set the wallpaper." >&2
        return 1
    fi

    if feh \
        --no-fehbg \
        --bg-fill \
        "$wallpaper"
    then
        update_wallpaper_link "$wallpaper"
    fi
}

find_random_wallpaper() {
    find "$WALLPAPERS_DIR" \
        -type f \
        \( \
            -iname "*.jpg" \
            -o -iname "*.jpeg" \
            -o -iname "*.png" \
            -o -iname "*.webp" \
        \) \
        ! -name ".current.wall" \
        2>/dev/null |
        shuf -n 1
}

apply_current_wallpaper() {
    local target_wall=""

    if [[ -L "$CURRENT_WALL_LINK" ]]; then
        target_wall="$(readlink -f "$CURRENT_WALL_LINK" 2>/dev/null || true)"

        if [[ ! -f "$target_wall" ]]; then
            target_wall=""
        fi
    fi

    if [[ -z "$target_wall" ]]; then
        echo "Current wallpaper link missing or broken. Selecting random..."

        target_wall="$(find_random_wallpaper)"

        if [[ -z "$target_wall" ]]; then
            echo "No wallpapers found in $WALLPAPERS_DIR" >&2
            return 1
        fi
    fi

    apply_wallpaper "$target_wall"
}

case "${1:-}" in
    --current)
        apply_current_wallpaper
        ;;

    "")
        echo "Usage: $0 {--current|wallpaper}" >&2
        exit 1
        ;;

    *)
        if [[ ! -f "$1" ]]; then
            echo "File not found: $1" >&2
            exit 1
        fi

        apply_wallpaper "$1"
        ;;
esac
