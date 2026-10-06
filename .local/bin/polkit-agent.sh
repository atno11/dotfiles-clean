#!/usr/bin/env bash

AGENT="/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

if [[ ! -x "$AGENT" ]]; then
    echo "Polkit GNOME authentication agent not found." >&2
    exit 1
fi

exec "$AGENT"
