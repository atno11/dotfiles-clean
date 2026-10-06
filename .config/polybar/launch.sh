#!/usr/bin/env bash

set -u

CONFIG="$HOME/.config/polybar/config.ini"

# Encerra instâncias anteriores.
killall -q polybar 2>/dev/null || true

while pgrep -x polybar >/dev/null; do
    sleep 0.1
done

# Prioriza a saída marcada como primary no RandR.
MONITOR="$(
    xrandr --query 2>/dev/null |
        awk '/ connected primary / { print $1; exit }'
)"

# Fallback: primeira saída conectada.
if [[ -z "$MONITOR" ]]; then
    MONITOR="$(
        xrandr --query 2>/dev/null |
            awk '/ connected/ { print $1; exit }'
    )"
fi

if [[ -z "$MONITOR" ]]; then
    echo "Polybar: nenhum monitor conectado encontrado." >&2
    exit 1
fi

MONITOR="$MONITOR" polybar \
    --config="$CONFIG" \
    --reload main &
