
#!/usr/bin/env bash

set -u

# Wallpaper Selector
# Native Rofi tabs for static and animated wallpapers.
# Preserves legacy directories and Pawlette integration.

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

WALLPAPER_ROOT="${WALLPAPER_ROOT:-/mnt/share/images/wallpapers}"

WALLPAPERS_DIRS=(
    "$WALLPAPER_ROOT/static"
    "$WALLPAPER_ROOT/animated"
    "$DATA_HOME/wallpapers"
    "$DATA_HOME/pawlette/theme_wallpapers"
)

CACHE_DIR="$CACHE_HOME/mewline/thumbs"
LOCK_FILE="$CACHE_DIR/cache.lock"
LOG_FILE="$CACHE_DIR/wallpaper-selector.log"

ROFI_THEME="$HOME/.config/rofi/selecting.rasi"

THUMB_SIZE=500
THUMB_RADIUS=15

SCRIPT_PATH="$(realpath -- "${BASH_SOURCE[0]}")" || exit 1
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"
SET_WALLPAPER_SCRIPT="$SCRIPT_DIR/../set-wallpaper.sh"

mkdir -p "$CACHE_DIR" || exit 1

log_message() {
    printf '[%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$*" >> "$LOG_FILE"
}

log_error() {
    printf 'Wallpaper Selector: %s\n' "$*" >&2
    log_message "ERROR: $*"
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        log_error "Missing required command: $1"
        return 1
    fi
}

wallpaper_type() {
    local file="${1,,}"

    case "$file" in
        *.jpg|*.jpeg|*.png|*.webp)
            printf 'static\n'
            ;;
        *.gif|*.mp4|*.webm|*.mkv|*.mov|*.m4v)
            printf 'animated\n'
            ;;
        *)
            return 1
            ;;
    esac
}

get_hash() {
    local path

    path="$(realpath -- "$1")" || return 1

    printf '%s' "$path" |
        sha256sum |
        cut -d ' ' -f 1
}

thumbnail_path() {
    local hash

    hash="$(get_hash "$1")" || return 1

    printf '%s/%s.png\n' "$CACHE_DIR" "$hash"
}

apply_rounded_mask() {
    local input="$1"
    local output="$2"

    magick "$input" \
        -auto-orient \
        -thumbnail "${THUMB_SIZE}x${THUMB_SIZE}^" \
        -gravity center \
        -background none \
        -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
        \( \
            -size "${THUMB_SIZE}x${THUMB_SIZE}" \
            xc:none \
            -fill white \
            -draw \
                "roundrectangle 0,0 $((THUMB_SIZE - 1)),$((THUMB_SIZE - 1)) $THUMB_RADIUS,$THUMB_RADIUS" \
        \) \
        -alpha off \
        -compose CopyOpacity \
        -composite \
        "$output"
}

extract_video_frame() {
    local input="$1"
    local output="$2"
    local directory
    local frame=""

    directory="$(
        mktemp -d "$CACHE_DIR/video.XXXXXXXX"
    )" || return 1

    if ! mpv \
        --no-config \
        --no-audio \
        --no-sub \
        --frames=1 \
        --vo=image \
        --vo-image-format=png \
        --vo-image-outdir="$directory" \
        --really-quiet \
        -- "$input" \
        >/dev/null 2>&1
    then
        rm -r -- "$directory"
        return 1
    fi

    while IFS= read -r -d '' candidate; do
        frame="$candidate"
        break
    done < <(
        find "$directory" \
            -maxdepth 1 \
            -type f \
            -iname '*.png' \
            -print0
    )

    if [[ -z "$frame" ]]; then
        rm -r -- "$directory"
        return 1
    fi

    if ! cp -- "$frame" "$output"; then
        rm -r -- "$directory"
        return 1
    fi

    rm -r -- "$directory"
}

generate_thumbnail() {
    local wallpaper="$1"
    local thumbnail="$2"
    local type
    local source
    local temporary_dir
    local result=0

    type="$(wallpaper_type "$wallpaper")" || return 1

    temporary_dir="$(
        mktemp -d "$CACHE_DIR/thumb.XXXXXXXX"
    )" || return 1

    source="$wallpaper"

    case "$type" in
        static)
            ;;
        animated)
            case "${wallpaper,,}" in
                *.gif)
                    source="${wallpaper}[0]"
                    ;;
                *)
                    source="$temporary_dir/frame.png"

                    if ! extract_video_frame \
                        "$wallpaper" \
                        "$source"
                    then
                        result=1
                    fi
                    ;;
            esac
            ;;
    esac

    if (( result == 0 )); then
        if ! apply_rounded_mask \
            "$source" \
            "$temporary_dir/thumbnail.png" \
            2>/dev/null
        then
            result=1
        fi
    fi

    if (( result == 0 )); then
        if ! mv -f -- \
            "$temporary_dir/thumbnail.png" \
            "$thumbnail"
        then
            result=1
        fi
    fi

    rm -r -- "$temporary_dir"

    return "$result"
}

declare -a STATIC_WALLPAPERS=()
declare -a STATIC_THUMBNAILS=()

declare -a ANIMATED_WALLPAPERS=()
declare -a ANIMATED_THUMBNAILS=()

declare -a WALLPAPERS=()
declare -a THUMBNAILS=()

declare -A SEEN_PATHS=()

discover_wallpapers() {
    local directory
    local file
    local canonical
    local thumbnail
    local type

    for directory in "${WALLPAPERS_DIRS[@]}"; do
        [[ -d "$directory" ]] || continue

        while IFS= read -r -d '' file; do
            canonical="$(realpath -- "$file")" || continue

            [[ -f "$canonical" ]] || continue
            [[ "$file" == */.current.wall ]] && continue

            if [[ -v SEEN_PATHS["$canonical"] ]]; then
                continue
            fi

            type="$(wallpaper_type "$canonical")" || continue
            thumbnail="$(thumbnail_path "$canonical")" || continue

            SEEN_PATHS["$canonical"]=1

            case "$type" in
                static)
                    STATIC_WALLPAPERS+=("$canonical")
                    STATIC_THUMBNAILS+=("$thumbnail")
                    ;;
                animated)
                    ANIMATED_WALLPAPERS+=("$canonical")
                    ANIMATED_THUMBNAILS+=("$thumbnail")
                    ;;
            esac
        done < <(
            find -L "$directory" \
                -type f \
                \( \
                    -iname '*.jpg' \
                    -o -iname '*.jpeg' \
                    -o -iname '*.png' \
                    -o -iname '*.webp' \
                    -o -iname '*.gif' \
                    -o -iname '*.mp4' \
                    -o -iname '*.webm' \
                    -o -iname '*.mkv' \
                    -o -iname '*.mov' \
                    -o -iname '*.m4v' \
                \) \
                -print0 2>/dev/null |
                sort -z
        )
    done
}

load_category() {
    WALLPAPERS=()
    THUMBNAILS=()

    case "$1" in
        static)
            WALLPAPERS=("${STATIC_WALLPAPERS[@]}")
            THUMBNAILS=("${STATIC_THUMBNAILS[@]}")
            ;;
        animated)
            WALLPAPERS=("${ANIMATED_WALLPAPERS[@]}")
            THUMBNAILS=("${ANIMATED_THUMBNAILS[@]}")
            ;;
        *)
            return 1
            ;;
    esac
}

generate_missing_thumbnails() {
    local index
    local wallpaper
    local thumbnail

    for index in "${!WALLPAPERS[@]}"; do
        wallpaper="${WALLPAPERS[$index]}"
        thumbnail="${THUMBNAILS[$index]}"

        if [[ -f "$thumbnail" &&
              ! "$wallpaper" -nt "$thumbnail" ]]; then
            continue
        fi

        if ! generate_thumbnail "$wallpaper" "$thumbnail"; then
            log_error "Preview failed: $wallpaper"
        fi
    done
}

generate_mode_entries() {
    local index
    local wallpaper
    local thumbnail
    local label

    printf 'Random Wallpaper\0icon\x1fmedia-playlist-shuffle\x1finfo\x1frandom\n'

    for index in "${!WALLPAPERS[@]}"; do
        wallpaper="${WALLPAPERS[$index]}"
        thumbnail="${THUMBNAILS[$index]}"
        label="$(basename -- "$wallpaper")"

        if [[ -f "$thumbnail" ]]; then
            printf '%s\0icon\x1f%s\x1finfo\x1f%s\n' \
                "$label" "$thumbnail" "$wallpaper"
        else
            printf '%s\0icon\x1fimage-x-generic\x1finfo\x1f%s\n' \
                "$label" "$wallpaper"
        fi
    done
}

select_random_wallpaper() {
    local count="${#WALLPAPERS[@]}"
    local index

    if (( count == 0 )); then
        log_error "No wallpapers in selected category."
        return 1
    fi

    index=$((RANDOM % count))
    printf '%s\n' "${WALLPAPERS[$index]}"
}

# Launch wallpaper application outside the Rofi script process.
# Log the actual exit code from set-wallpaper.sh.
apply_selected_wallpaper() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        log_error "Wallpaper not found: $wallpaper"
        return 1
    fi

    if [[ ! -f "$SET_WALLPAPER_SCRIPT" ]]; then
        log_error "Missing application script: $SET_WALLPAPER_SCRIPT"
        return 1
    fi

    require_command setsid || return 1

    log_message "Dispatching wallpaper: $wallpaper"

    setsid -f bash -c '
        script="$1"
        wallpaper="$2"
        logfile="$3"

        bash "$script" "$wallpaper" >> "$logfile" 2>&1
        status=$?

        printf "[%s] Application exit status: %s\n" \
            "$(date "+%Y-%m-%d %H:%M:%S")" \
            "$status" >> "$logfile"

        exit "$status"
    ' _ \
        "$SET_WALLPAPER_SCRIPT" \
        "$wallpaper" \
        "$LOG_FILE" \
        >/dev/null 2>&1 </dev/null
}

run_rofi_mode() {
    local category="$1"
    local wallpaper
    local candidate
    local found=0

    discover_wallpapers
    load_category "$category" || return 1

    log_message \
        "Rofi mode=$category retv=${ROFI_RETV:-0}"

    case "${ROFI_RETV:-0}" in
        0)
            (
                exec 9>"$LOCK_FILE"
                flock -x 9 || exit 1
                generate_missing_thumbnails
            ) || return 1

            generate_mode_entries
            ;;
        1)
            log_message \
                "Selection received: ${ROFI_INFO:-<empty>}"

            if [[ "${ROFI_INFO:-}" == "random" ]]; then
                wallpaper="$(select_random_wallpaper)" ||
                    return 1
            else
                wallpaper="${ROFI_INFO:-}"

                for candidate in "${WALLPAPERS[@]}"; do
                    if [[ "$candidate" == "$wallpaper" ]]; then
                        found=1
                        break
                    fi
                done

                if (( found != 1 )); then
                    log_error \
                        "Selection not found in $category: $wallpaper"
                    return 1
                fi
            fi

            apply_selected_wallpaper "$wallpaper"
            ;;
        *)
            log_message "Unhandled Rofi return value."
            return 0
            ;;
    esac
}

launch_rofi() {
    local -a arguments=(
        -show "Estáticos"
        -modi "Estáticos:$SCRIPT_PATH --mode-static,Animados:$SCRIPT_PATH --mode-animated"
        -show-icons
    )

    if [[ -f "$ROFI_THEME" ]]; then
        arguments+=(-theme "$ROFI_THEME")
    fi

    arguments+=(
        -theme-str '
            mainbox {
                children: [ mode-switcher, inputbar, listview ];
            }

            mode-switcher {
                enabled: true;
                orientation: horizontal;
                spacing: 8px;
                padding: 16px 20px 6px 20px;
                background-color: @main-bg;
            }

            button {
                expand: true;
                padding: 10px 14px;
                border-radius: 10px;
                background-color: transparent;
                text-color: @main-fg;
                horizontal-align: 0.5;
            }

            button selected {
                background-color: @select-bg;
                text-color: @select-fg;
            }
        '
    )

    rofi "${arguments[@]}"
}

main() {
    local category
    local wallpaper
    local index
    local -a all_wallpapers=()

    require_command magick || return 1
    require_command mpv || return 1
    require_command rofi || return 1
    require_command sha256sum || return 1
    require_command flock || return 1

    case "${1:-}" in
        --mode-static)
            run_rofi_mode static
            return $?
            ;;
        --mode-animated)
            run_rofi_mode animated
            return $?
            ;;
    esac

    discover_wallpapers

    all_wallpapers=(
        "${STATIC_WALLPAPERS[@]}"
        "${ANIMATED_WALLPAPERS[@]}"
    )

    if (( ${#all_wallpapers[@]} == 0 )); then
        log_error "No wallpapers found."
        return 1
    fi

    case "${1:-}" in
        --random)
            index=$((RANDOM % ${#all_wallpapers[@]}))
            apply_selected_wallpaper "${all_wallpapers[$index]}"
            ;;
        --static|--animated)
            category="${1#--}"
            load_category "$category" || return 1
            wallpaper="$(select_random_wallpaper)" || return 1
            apply_selected_wallpaper "$wallpaper"
            ;;
        "")
            launch_rofi
            ;;
        *)
            log_error "Unknown option: $1"
            return 1
            ;;
    esac
}

main "$@"
