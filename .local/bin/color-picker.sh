#!/usr/bin/env bash

if ! command -v xcolor >/dev/null 2>&1; then
    echo "xcolor is required." >&2
    exit 1
fi

xcolor -s clipboard
