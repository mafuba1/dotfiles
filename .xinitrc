setxkbmap us,ru -variant altgr-intl, -option grp:alt_shift_toggle -model pc86

xset -dpms
xset s off
xset s noblank

systemctl --user restart xsession.target

exec dwm

