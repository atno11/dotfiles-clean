#!/usr/bin/env bash

# Reinicia o daemon de atalhos com a configuração deste diretório.
pkill -x sxhkd 2>/dev/null || true
sxhkd -c "$HOME/.config/bspwm/sxhkdrc" &

# Deskflow
pkill -x deskflow 2>/dev/null || true
pkill -x deskflow-core 2>/dev/null || true

deskflow-core client 192.168.0.100 & disown

# Os terminais automáticos antigos foram removidos daqui.
# Eles eram abertos no desktop ativo durante cada reload do bspwm e podiam
# deixar a árvore/janelas em um estado confuso ao alternar os monitores.
