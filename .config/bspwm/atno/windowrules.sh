#!/usr/bin/env bash

SCREEN_SIZE="$(
    xdpyinfo 2>/dev/null |
        awk '/dimensions:/ { print $2; exit }'
)"

if [[ ! "$SCREEN_SIZE" =~ ^([0-9]+)x([0-9]+)$ ]]; then
    echo "BSPWM: não foi possível determinar a resolução da tela." >&2
    return 1
fi

SW="${BASH_REMATCH[1]}"
SH="${BASH_REMATCH[2]}"

rect() {
    local w_pct="$1"
    local h_pct="$2"

    local w
    local h
    local x
    local y

    w=$((SW * w_pct / 100))
    h=$((SH * h_pct / 100))

    x=$(((SW - w) / 2))
    y=$(((SH - h) / 2))

    printf '%sx%s+%s+%s\n' \
        "$w" \
        "$h" \
        "$x" \
        "$y"
}

bspc rule -a feh \
    state=floating

bspc rule -a '*:sun-awt-X11-XWindowPeer' \
    manage=off

bspc rule -a vlc \
    state=floating \
    center=true

bspc rule -a Blueman-manager \
    state=floating \
    center=true

bspc rule -a qt5ct \
    state=floating \
    center=true

bspc rule -a qt6ct \
    state=floating \
    center=true

bspc rule -a ark \
    state=floating \
    center=true

bspc rule -a Xarchiver \
    state=floating \
    center=true

bspc rule -a Yad \
    state=floating \
    center=true

bspc rule -a org.gnome.FileRoller \
    state=floating \
    rectangle="$(rect 63 74)" \
    center=true

bspc rule -a Gnome-calculator \
    state=floating \
    rectangle="$(rect 19 47)" \
    center=true

bspc rule -a loupe \
    state=floating \
    rectangle="$(rect 63 74)" \
    center=true

bspc rule -a qalculate-gtk \
    state=floating \
    rectangle="$(rect 45 55)" \
    center=true

bspc rule -a pavucontrol \
    state=floating \
    rectangle="$(rect 48 42)" \
    center=true
