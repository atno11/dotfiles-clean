#!/usr/bin/env bash

# Start the hotkey daemon using the canonical sxhkd configuration.
SXHKD_CONFIG="$HOME/.config/sxhkd/sxhkdrc"

if ! command -v sxhkd >/dev/null 2>&1; then
    printf 'ERROR: sxhkd is not installed.\n' >&2
elif [[ ! -r "$SXHKD_CONFIG" ]]; then
    printf 'ERROR: sxhkd configuration not found: %s\n' "$SXHKD_CONFIG" >&2
else
    # Stop stale instances, including those using legacy configurations.
    pkill -u "$(id -u)" -TERM -x sxhkd 2>/dev/null || true

    # Wait until old instances release their X11 key grabs.
    for ((attempt = 0; attempt < 30; attempt++)); do
        if ! pgrep -u "$(id -u)" -x sxhkd >/dev/null 2>&1; then
            break
        fi

        sleep 0.1
    done

    if pgrep -u "$(id -u)" -x sxhkd >/dev/null 2>&1; then
        printf 'ERROR: previous sxhkd instances are still running.\n' >&2
    else
        sxhkd -c "$SXHKD_CONFIG" &
    fi
fi
