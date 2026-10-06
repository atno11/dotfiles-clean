# #bspc monitor -d 1 2 3 4 5 6 7 8 9 10
# #bspc config focus_follows_pointer true
# #
# ## HDMI invertido
# #if xrandr --query | grep -q "^HDMI-A-0 connected"; then
# #    xrandr --output HDMI-A-0 --mode 1920x1080 --rotate inverted
# #fi
# #
# ## DisplayPort normal
# #if xrandr --query | grep -q "^DisplayPort-0 connected"; then
# #    xrandr --output DisplayPort-0 --mode 1280x800 --rotate normal
# #fi


# # --- Detecta outputs conectados
CONNECTED="$(xrandr --query | awk '/ connected/{print $1}')"

# # --- Defina aqui seu monitor principal
PRIMARY="HDMI-A-0"

 # --- Desliga qualquer "DisplayPort-*" (geralmente placa de captura)
 for out in $CONNECTED; do
   case "$out" in
     DisplayPort-*|DP-*)
       xrandr --output "$out" --off || true
       ;;
   esac
 done

 # --- Configura o HDMI como principal (invertido)
 if echo "$CONNECTED" | grep -qx "$PRIMARY"; then
   xrandr --output "$PRIMARY" --mode 1920x1080 --rotate inverted --primary
 fi

# # --- Espera o X assentar
 sleep 0.5

# # --- Remove monitores/desktops antigos e aplica desktops só no HDMI
# # (garante que os desktops vão ficar no monitor certo)
 bspc monitor "$PRIMARY" -d 1 2 3 4 5 6 7 8 9 10

# # --- Opcional: remove desktops de outros monitores (se existirem)
 for m in $(bspc query -M --names); do
   [ "$m" = "$PRIMARY" ] && continue
   # Move desktops desse monitor pro PRIMARY e remove o monitor
   for d in $(bspc query -D -m "$m" --names); do
    bspc desktop "$d" -m "$PRIMARY" || true
   done
 done

# # --- Preferências do bspwm
bspc config focus_follows_pointer true

# Aplica perfil salvo pelo EDID
#autorandr --change &

# Aguarda aplicar layout
#sleep 1

#bspc config focus_follows_pointer true

# Descobre monitor principal atual
#PRIMARY=$(xrandr --query | awk '/ primary /{print $1; exit}')

# Se não houver primary definido
#[ -z "$PRIMARY" ] && PRIMARY=$(bspc query -M --names | head -n1)

# Desktops no monitor principal
#bspc monitor "$PRIMARY" -d 1 2 3 4 5 6 7 8 9 10
