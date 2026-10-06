CORRECAO DO BSPWM - MONITOR VERTICAL
===================================
Arquivo alterado: atno/layout.sh
Os demais arquivos do seu ZIP foram mantidos.
BOTTOM e PARK recebem desktops tecnicos __atno_*_keep__ para que
nenhum B1..B6 fique preso quando alternar entre SPLIT e FULL.

Instalacao segura (no Arch, a partir do diretorio onde salvou o ZIP):
    mkdir -p ~/.config/bspwm/atno
    cp ~/.config/bspwm/atno/layout.sh ~/.config/bspwm/atno/layout.sh.bak
    unzip -p bspwm-corrigido.zip atno/layout.sh > ~/.config/bspwm/atno/layout.sh
    chmod +x ~/.config/bspwm/atno/layout.sh
    bash -n ~/.config/bspwm/atno/layout.sh

Aplicar sem reiniciar:
    ~/.config/bspwm/atno/layout.sh split

Conferir:
    xrandr --listmonitors
    bspc query -M --names
    for m in TOP BOTTOM PARK; do
        echo "=== $m ==="
        bspc query -T -m "$m" | jq '{name, rectangle, desktops: [.desktops[].name]}'
    done

Esperado no bspc (ordem pode variar): TOP, BOTTOM, PARK.
A configuracao xrandr tem somente TOP e BOTTOM.

Alternancia:
    ~/.config/bspwm/atno/layout.sh full
    ~/.config/bspwm/atno/layout.sh split

Reverter:
    cp ~/.config/bspwm/atno/layout.sh.bak ~/.config/bspwm/atno/layout.sh
    ~/.config/bspwm/atno/layout.sh split

Observacao: caso outro programa rode xrandr --output ou reorganize os
monitores apos a inicializacao, execute o layout.sh split para
reaplicar os retangulos. Esta versao evita o problema durante a
inicializacao e durante a alternancia normal de workspaces.
