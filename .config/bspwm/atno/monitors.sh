#!/usr/bin/env bash

# Layout padrão:
# Workspaces lógicos 1..6 usam simultaneamente TOP + BOTTOM.
# Internamente: T1..T6 no TOP e B1..B6 no BOTTOM.
# Workspaces 7..9 usam o monitor inteiro e são ativados sob demanda.

LAYOUT_NO_BAR=1 LAYOUT_NO_WALLPAPER=1 "$HOME/.config/bspwm/atno/layout.sh" split

# Inicia no workspace lógico 1 nas duas metades.
bspc desktop T1 -f 2>/dev/null || true
bspc desktop B1 -f 2>/dev/null || true
bspc monitor TOP -f 2>/dev/null || true
