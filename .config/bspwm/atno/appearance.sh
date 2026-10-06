#!/usr/bin/env bash

bspc config focused_border_color "#b4befe"
bspc config border_width 3
bspc config borderless_monocle true

xsetroot -cursor_name left_ptr

bspc config gapless_monocle false
bspc config window_gap 10

bspc config pointer_modifier mod4
bspc config pointer_action1 move
bspc config pointer_action2 resize_side
bspc config pointer_action3 resize_corner
