xset -dpms
xset s off
xset s noblank

systemctl --user start xsession.target

dwm

systemctl --user stop xsession.target

exit 0
