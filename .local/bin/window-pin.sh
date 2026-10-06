#!/usr/bin/env bash

win_id="$(bspc query -N -n focused 2>/dev/null)" || exit 0

[[ -n "$win_id" ]] || exit 0

is_sticky="$(bspc query -N -n "$win_id.sticky" 2>/dev/null || true)"
is_locked="$(bspc query -N -n "$win_id.locked" 2>/dev/null || true)"

if [[ -n "$is_sticky" && -n "$is_locked" ]]; then
    bspc node "$win_id" -g sticky=off
    bspc node "$win_id" -g locked=off
    exit 0
fi

if ! bspc query -N -n "$win_id.floating" >/dev/null 2>&1; then
    bspc node "$win_id" -t floating
fi

bspc node "$win_id" -g sticky=on
bspc node "$win_id" -g locked=on
bspc node "$win_id" -f
