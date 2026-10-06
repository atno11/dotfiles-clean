#!/usr/bin/env bash

DEFAULT_UPDATED_COLOR="#a6e3a1"
DEFAULT_UNUPDATED_COLOR="#fab387"
DEFAULT_TERMINAL="ghostty"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/system-update"
CACHE_FILE="$CACHE_DIR/updates.cache"
CACHE_DURATION=300

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --status                 Show update status."
    echo "  --updated-color COLOR    Color when there are no updates."
    echo "  --unupdated-color COLOR  Color when updates are available."
    echo "  --terminal TERMINAL      Terminal used for the upgrade."
    echo "  --force                  Ignore cache and check again."
    echo "  --help                   Show this message."
    echo
    echo "Examples:"
    echo "  $0 --status"
    echo "  $0 --status --force"
    echo "  $0 --terminal ghostty"
}

ensure_cache_dir() {
    mkdir -p "$CACHE_DIR"
}

is_cache_valid() {
    [[ -f "$CACHE_FILE" ]] || return 1

    local current_time
    local cache_time
    local age

    current_time="$(date +%s)"
    cache_time="$(stat -c %Y "$CACHE_FILE" 2>/dev/null)" || return 1

    age=$((current_time - cache_time))

    (( age < CACHE_DURATION ))
}

read_cache() {
    cat "$CACHE_FILE" 2>/dev/null || echo 0
}

write_cache() {
    printf '%s\n' "$1" > "$CACHE_FILE"
}

invalidate_cache() {
    rm -f "$CACHE_FILE"
}

check_release() {
    [[ -f /etc/arch-release ]]
}

get_aur_helper() {
    if command -v yay >/dev/null 2>&1; then
        echo "yay"
    elif command -v paru >/dev/null 2>&1; then
        echo "paru"
    fi
}

check_official_updates() {
    local count=0

    if command -v checkupdates >/dev/null 2>&1; then
        count="$(
            checkupdates 2>/dev/null |
                wc -l
        )"
    fi

    echo "$count"
}

check_aur_updates() {
    local aur_helper
    local count=0

    aur_helper="$(get_aur_helper)"

    if [[ -n "$aur_helper" ]]; then
        count="$(
            "$aur_helper" -Qua 2>/dev/null |
                wc -l
        )"
    fi

    echo "$count"
}

check_flatpak_updates() {
    local count=0

    if command -v flatpak >/dev/null 2>&1; then
        count="$(
            flatpak remote-ls --updates 2>/dev/null |
                wc -l
        )"
    fi

    echo "$count"
}

calculate_updates() {
    local force_check="${1:-0}"

    ensure_cache_dir

    if (( force_check == 0 )) && is_cache_valid; then
        read_cache
        return
    fi

    local official
    local aur
    local flatpak
    local total

    official="$(check_official_updates)"
    aur="$(check_aur_updates)"
    flatpak="$(check_flatpak_updates)"

    total=$((official + aur + flatpak))

    write_cache "$total"
    echo "$total"
}

print_status() {
    local updated_color="$1"
    local unupdated_color="$2"
    local force_check="${3:-0}"

    local updates
    local color

    updates="$(calculate_updates "$force_check")"
    color="$unupdated_color"

    if (( updates == 0 )); then
        updates=""
        color="$updated_color"
    fi

    printf '%%{F%s}󰮯 %s %%{F-}\n' "$color" "$updates"
}

build_upgrade_command() {
    local aur_helper

    aur_helper="$(get_aur_helper)"

    if [[ -n "$aur_helper" ]]; then
        printf '%s' "$aur_helper -Syu"
    else
        printf '%s' "sudo pacman -Syu"
    fi

    if command -v flatpak >/dev/null 2>&1; then
        printf '%s' " && flatpak update -y"
    fi

    printf '%s' '; printf "\nPress any key to close..."; read -r -n 1'
}

trigger_upgrade() {
    local terminal="${1:-$DEFAULT_TERMINAL}"
    local command

    command="$(build_upgrade_command)"

    case "$terminal" in
        ghostty)
            ghostty -e bash -lc "$command"
            ;;
        *)
            echo "Unsupported terminal: $terminal" >&2
            echo "Command:"
            echo "$command"
            return 1
            ;;
    esac

    invalidate_cache
}

main() {
    check_release || exit 0

    local updated_color="$DEFAULT_UPDATED_COLOR"
    local unupdated_color="$DEFAULT_UNUPDATED_COLOR"
    local terminal="$DEFAULT_TERMINAL"
    local status=false
    local force_check=0

    while (( $# > 0 )); do
        case "$1" in
            --status)
                status=true
                ;;

            --updated-color)
                [[ $# -ge 2 ]] || {
                    echo "Missing value for --updated-color" >&2
                    exit 1
                }

                updated_color="$2"
                shift
                ;;

            --unupdated-color)
                [[ $# -ge 2 ]] || {
                    echo "Missing value for --unupdated-color" >&2
                    exit 1
                }

                unupdated_color="$2"
                shift
                ;;

            --terminal)
                [[ $# -ge 2 ]] || {
                    echo "Missing value for --terminal" >&2
                    exit 1
                }

                terminal="$2"
                shift
                ;;

            --force)
                force_check=1
                ;;

            --help)
                show_help
                exit 0
                ;;

            *)
                echo "Unknown argument: $1" >&2
                show_help
                exit 1
                ;;
        esac

        shift
    done

    if $status; then
        print_status \
            "$updated_color" \
            "$unupdated_color" \
            "$force_check"
    else
        trigger_upgrade "$terminal"
    fi
}

main "$@"
