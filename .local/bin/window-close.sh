#!/usr/bin/env bash

win_id="$(bspc query -N -n focused 2>/dev/null)" || exit 0

[[ -n "$win_id" ]] || exit 0

if bspc query -N -n "$win_id.sticky" >/dev/null 2>&1; then
    bspc node "$win_id" -g sticky=off
fi

if bspc query -N -n "$win_id.locked" >/dev/null 2>&1; then
    bspc node "$win_id" -g locked=off
fi

bspc node "$win_id" -c
