#!/usr/bin/env bash

set -u

CONFIG="$HOME/.config/polybar/config.ini"

# Encerra instâncias anteriores.
killall -q polybar 2>/dev/null || true
while pgrep -x polybar >/dev/null; do
    sleep 0.1
done

# A Polybar usa os monitor objects do RandR. O script de layout deve
# criar TOP/BOTTOM no modo dividido e FULL no modo inteiro.
mapfile -t MONITORS < <(
    xrandr --listmonitors 2>/dev/null \
        | tail -n +2 \
        | awk '{name=$2; sub(/^\+/, "", name); sub(/^\*/, "", name); sub(/^\+\*/, "", name); print name}'
)

has_monitor() {
    local wanted="$1"
    local monitor

    for monitor in "${MONITORS[@]}"; do
        [[ "$monitor" == "$wanted" ]] && return 0
    done

    return 1
}

if has_monitor TOP && has_monitor BOTTOM; then
    polybar --config="$CONFIG" --reload top &
    polybar --config="$CONFIG" --reload bottom &
elif has_monitor FULL; then
    polybar --config="$CONFIG" --reload full &
else
    # Fallback para não ficar sem barra caso o layout virtual ainda não
    # tenha sido criado. Usa o primeiro monitor RandR disponível.
    FALLBACK_MONITOR="${MONITORS[0]:-}"

    if [[ -n "$FALLBACK_MONITOR" ]]; then
        MONITOR="$FALLBACK_MONITOR" polybar --config="$CONFIG" --reload fallback &
    fi
fi
