#!/usr/bin/env bash

PRIMARY="$(
    xrandr --query 2>/dev/null |
        awk '/ connected primary / { print $1; exit }'
)"

if [[ -z "$PRIMARY" ]]; then
    PRIMARY="$(
        xrandr --query 2>/dev/null |
            awk '/ connected/ { print $1; exit }'
    )"
fi

if [[ -z "$PRIMARY" ]]; then
    echo "BSPWM: nenhum monitor conectado encontrado." >&2
    return 1
fi

# Normalmente o nome do monitor BSPWM corresponde à saída RandR.
# Caso isso ainda não tenha acontecido, usa o primeiro monitor conhecido
# pelo BSPWM sem assumir um nome específico de saída.
if bspc query -M --names 2>/dev/null | grep -Fxq "$PRIMARY"; then
    MONITOR="$PRIMARY"
else
    MONITOR="$(
        bspc query -M --names 2>/dev/null |
            head -n 1
    )"
fi

if [[ -z "$MONITOR" ]]; then
    echo "BSPWM: nenhum monitor disponível." >&2
    return 1
fi

has_desktop() {
    bspc query -D --names 2>/dev/null |
        grep -Fxq "$1"
}

# Em uma sessão nova, o BSPWM normalmente cria um único desktop
# chamado "Desktop". Aproveitamos esse desktop existente como workspace 1,
# evitando remover/recriar desktops desnecessariamente.
if ! has_desktop 1; then
    DEFAULT_DESKTOP="$(
        bspc query -D -m "$MONITOR" --names 2>/dev/null |
            head -n 1
    )"

    if [[ "$DEFAULT_DESKTOP" == "Desktop" ]]; then
        bspc desktop "$DEFAULT_DESKTOP" -n 1
    else
        bspc monitor "$MONITOR" -a 1
    fi
fi

# Cria somente os workspaces que ainda não existem.
# Em reloads, 1..9 já existem e nada é alterado.
for DESKTOP in 2 3 4 5 6 7 8 9; do
    if ! has_desktop "$DESKTOP"; then
        bspc monitor "$MONITOR" -a "$DESKTOP"
    fi
done

bspc config focus_follows_pointer true
