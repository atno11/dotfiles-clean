
#!/usr/bin/env bash

set -u

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

WALLPAPERS_DIR="$DATA_HOME/wallpapers"
CURRENT_WALL_LINK="$WALLPAPERS_DIR/.current.wall"

RUNTIME_BASE="${XDG_RUNTIME_DIR:-$CACHE_HOME}"
RUNTIME_DIR="$RUNTIME_BASE/dotfiles-wallpaper"

PID_FILE="$RUNTIME_DIR/animated-wallpaper.pids"
LOCK_FILE="$RUNTIME_DIR/wallpaper.lock"
LOG_FILE="$RUNTIME_DIR/animated-wallpaper.log"

umask 077

mkdir -p "$WALLPAPERS_DIR" "$RUNTIME_DIR" || exit 1

if ! command -v flock >/dev/null 2>&1; then
    echo "Missing required command: flock" >&2
    exit 1
fi

# Serialize wallpaper changes.
exec 9>"$LOCK_FILE"
flock -x 9 || exit 1

log() {
    printf '[%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$*" >> "$LOG_FILE"
}

fail() {
    printf 'Wallpaper error: %s\n' "$*" >&2
    log "ERROR: $*"
    return 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        fail "Required command not found: $1"
        return 1
    }
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

update_wallpaper_link() {
    local target
    local temporary_link

    target="$(realpath -- "$1")" || return 1
    temporary_link="$WALLPAPERS_DIR/.current.wall.tmp.$$"

    if ! ln -s -- "$target" "$temporary_link"; then
        fail "Could not create temporary wallpaper link."
        return 1
    fi

    if ! mv -Tf -- "$temporary_link" "$CURRENT_WALL_LINK"; then
        rm -f -- "$temporary_link"
        fail "Could not update current wallpaper."
        return 1
    fi
}

process_start_time() {
    local pid="$1"
    local stat_line
    local remainder

    [[ -r "/proc/$pid/stat" ]] || return 1

    IFS= read -r stat_line < "/proc/$pid/stat" || return 1
    remainder="${stat_line##*) }"

    # /proc/PID/stat field 22 becomes field 20.
    awk '{print $20}' <<< "$remainder"
}

is_managed_process() {
    local pid="$1"
    local expected_start="$2"
    local current_start
    local process_name

    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    [[ "$expected_start" =~ ^[0-9]+$ ]] || return 1
    [[ -r "/proc/$pid/comm" ]] || return 1

    process_name="$(<"/proc/$pid/comm")"

    [[ "$process_name" == "xwinwrap" ]] || return 1

    current_start="$(process_start_time "$pid")" || return 1

    [[ "$current_start" == "$expected_start" ]]
}

stop_animated_wallpaper() {
    local pid
    local start_time
    local attempt
    local failed=0

    [[ -f "$PID_FILE" ]] || return 0

    require_command pkill || return 1

    while read -r pid start_time; do
        if ! is_managed_process "$pid" "$start_time"; then
            continue
        fi

        log "Stopping managed xwinwrap PID $pid"

        # Only signal children of our registered wrapper.
        pkill -TERM -P "$pid" 2>/dev/null || true
        kill -TERM "$pid" 2>/dev/null || true

        for ((attempt = 0; attempt < 20; attempt++)); do
            if ! is_managed_process "$pid" "$start_time"; then
                break
            fi

            sleep 0.1
        done

        if is_managed_process "$pid" "$start_time"; then
            log "Managed process did not terminate: $pid"
            failed=1
        fi
    done < "$PID_FILE"

    if (( failed != 0 )); then
        fail "One or more managed processes remain active."
        return 1
    fi

    rm -f -- "$PID_FILE"
}

get_monitor_geometries() {
    xrandr --query |
        awk '
            / connected/ {
                for (i = 1; i <= NF; i++) {
                    if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) {
                        print $i
                        break
                    }
                }
            }
        ' |
        sort -u
}

apply_static_wallpaper() {
    local wallpaper="$1"

    require_command feh || return 1

    if ! feh \
        --no-fehbg \
        --bg-fill \
        "$wallpaper"
    then
        fail "Failed to apply static wallpaper."
        return 1
    fi

    stop_animated_wallpaper || return 1
    update_wallpaper_link "$wallpaper" || return 1

    log "Static wallpaper applied: $wallpaper"
}

start_animation_process() {
    local wallpaper="$1"
    local geometry="$2"
    local pid
    local start_time=""
    local attempt

    log "Starting animation on $geometry"

    # Validated on BSPWM/X11 with xwinwrap-git r20.539fc47-1.
    #
    # %WID is replaced by xwinwrap.
    # -fdt assigns the desktop window type.
    # -ov must remain disabled because it caused X11 BadMatch.
    # --vo=x11 is the validated mpv video output.
    #
    # Close FD 9 in the background child. Otherwise xwinwrap/mpv
    # could retain the parent's exclusive wallpaper lock.
    xwinwrap \
        -g "$geometry" \
        -ni \
        -b \
        -s \
        -st \
        -sp \
        -nf \
        -un \
        -fdt \
        -- \
        mpv \
            --wid=%WID \
            --no-config \
            --no-audio \
            --loop-file=inf \
            --no-border \
            --no-osc \
            --no-osd-bar \
            --no-input-default-bindings \
            --input-vo-keyboard=no \
            --vo=x11 \
            --panscan=1.0 \
            -- \
            "$wallpaper" \
        >> "$LOG_FILE" 2>&1 </dev/null 9>&- &

    pid=$!

    for ((attempt = 0; attempt < 10; attempt++)); do
        start_time="$(
            process_start_time "$pid" 2>/dev/null
        )" || true

        if [[ "$start_time" =~ ^[0-9]+$ ]] &&
           is_managed_process "$pid" "$start_time"; then
            break
        fi

        sleep 0.05
    done

    if [[ ! "$start_time" =~ ^[0-9]+$ ]] ||
       ! is_managed_process "$pid" "$start_time"; then
        fail "Could not register xwinwrap process $pid."
        return 1
    fi

    printf '%s %s\n' "$pid" "$start_time" >> "$PID_FILE"

    log "Started xwinwrap PID $pid on $geometry"
}

verify_animation_processes() {
    local pid
    local start_time
    local count=0

    [[ -s "$PID_FILE" ]] || return 1

    while read -r pid start_time; do
        ((count += 1))

        if ! is_managed_process "$pid" "$start_time"; then
            log "Animation process exited: $pid"
            return 1
        fi
    done < "$PID_FILE"

    (( count > 0 ))
}

apply_animated_wallpaper() {
    local wallpaper="$1"
    local geometry
    local -a geometries=()

    require_command mpv || return 1
    require_command xwinwrap || return 1
    require_command xrandr || return 1
    require_command pkill || return 1

    if [[ -z "${DISPLAY:-}" ]]; then
        fail "DISPLAY is not set. X11 is required."
        return 1
    fi

    mapfile -t geometries < <(get_monitor_geometries)

    if (( ${#geometries[@]} == 0 )); then
        fail "No active monitor geometries detected."
        return 1
    fi

    log "Applying animated wallpaper: $wallpaper"

    stop_animated_wallpaper || return 1

    : > "$PID_FILE"

    for geometry in "${geometries[@]}"; do
        if ! start_animation_process "$wallpaper" "$geometry"; then
            stop_animated_wallpaper
            return 1
        fi
    done

    # Catch immediate startup failures.
    sleep 1

    if ! verify_animation_processes; then
        stop_animated_wallpaper
        fail "Animated wallpaper failed during startup."
        return 1
    fi

    if ! update_wallpaper_link "$wallpaper"; then
        stop_animated_wallpaper
        return 1
    fi

    log "Animated wallpaper applied: $wallpaper"
}

find_random_wallpaper() {
    find "$WALLPAPERS_DIR" \
        -type f \
        \( \
            -iname '*.jpg' \
            -o -iname '*.jpeg' \
            -o -iname '*.png' \
            -o -iname '*.webp' \
        \) \
        -print0 2>/dev/null |
        shuf -z -n 1 |
        tr -d '\0'
}

apply_current_wallpaper() {
    local target_wall=""

    if [[ -L "$CURRENT_WALL_LINK" ]]; then
        target_wall="$(
            readlink -f "$CURRENT_WALL_LINK" 2>/dev/null || true
        )"

        [[ -f "$target_wall" ]] || target_wall=""
    fi

    if [[ -z "$target_wall" ]]; then
        log "Current wallpaper missing. Selecting random."
        target_wall="$(find_random_wallpaper)"
    fi

    if [[ -z "$target_wall" ]]; then
        fail "No available wallpaper found."
        return 1
    fi

    apply_wallpaper "$target_wall"
}

apply_wallpaper() {
    local wallpaper="$1"
    local type

    if [[ ! -f "$wallpaper" ]]; then
        fail "File not found: $wallpaper"
        return 1
    fi

    wallpaper="$(realpath -- "$wallpaper")" || return 1

    type="$(wallpaper_type "$wallpaper")" || {
        fail "Unsupported wallpaper format: $wallpaper"
        return 1
    }

    case "$type" in
        static)
            apply_static_wallpaper "$wallpaper"
            ;;
        animated)
            apply_animated_wallpaper "$wallpaper"
            ;;
    esac
}

case "${1:-}" in
    --current)
        apply_current_wallpaper
        ;;
    --stop)
        stop_animated_wallpaper
        ;;
    "")
        echo "Usage: $0 {--current|--stop|wallpaper}" >&2
        exit 1
        ;;
    *)
        apply_wallpaper "$1"
        ;;
esac
