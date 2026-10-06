#!/usr/bin/env bash

# Reinicia o daemon de atalhos usando a configuração deste setup.
pkill -x sxhkd 2>/dev/null || true

if command -v sxhkd >/dev/null 2>&1; then
    sxhkd -c "$HOME/.config/bspwm/sxhkdrc" &
fi
