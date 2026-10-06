#!/usr/bin/env bash

pkill -x picom

sleep 0.2

picom --config ~/.config/picom/picom.conf & 
