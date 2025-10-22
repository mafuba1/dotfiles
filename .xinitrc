setxkbmap us,ru -variant altgr-intl, -option grp:alt_shift_toggle -model pc86

~/.local/share/dwmblocks/dwmblocks &
~/.local/bin/keyboard-watcher.sh &

picom --config ~/.local/share/picom/picom.conf &

sxhkd &
dunst -conf ~/.config/dunst/dunstrc &
flameshot &
xwallpaper --zoom ~/Pictures/ER_NIGHTREIGN.jpg

xset -dpms
xset s off
xset s noblank

exec dwm

