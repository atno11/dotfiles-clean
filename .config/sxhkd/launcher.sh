#!/usr/bin/env bash

pkill -x sxhkd

sleep 0.2

sxhkd -c ~/.config/sxhkd/sxhkdrc &
