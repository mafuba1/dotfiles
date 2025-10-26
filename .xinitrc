setxkbmap us,ru -variant altgr-intl, -option grp:alt_shift_toggle -model pc86

xset -dpms
xset s off
xset s noblank

systemctl --user start xsession.target

xwallpaper --zoom ~/Pictures/ER_NIGHTREIGN.jpg

dwm

systemctl --user stop xsession.target

exit 0
