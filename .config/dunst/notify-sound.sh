#!/usr/bin/env bash

# Avoid sounds for low-priority notifications.
case "${DUNST_URGENCY:-${5:-}}" in
    NORMAL|CRITICAL) ;;
    *) exit 0 ;;
esac

# Respect Do Not Disturb.
if command -v dunstctl >/dev/null 2>&1 &&
    [[ "$(dunstctl is-paused 2>/dev/null)" == "true" ]]; then
    exit 0
fi

# Play the Freedesktop notification sound.
if command -v canberra-gtk-play >/dev/null 2>&1; then
    canberra-gtk-play -i message-new-instant >/dev/null 2>&1
fi
