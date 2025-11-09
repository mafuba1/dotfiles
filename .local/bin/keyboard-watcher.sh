#!/bin/bash

pid=$(pgrep -n dwmblocks)
[ -z "$pid" ] && exit 1

prev_layout=no_layout

while read -r layout; do
    echo "Layout: $layout"
    [[ "$layout" == "$prev_layout" ]] && echo "Layout didn't change, exiting" && exit 1
    pkill -RTMIN+1 dwmblocks || kill -RTMIN+1 "$pid" 
    prev_layout=$layout
done < <(xkb-switch -W)
exit ${PIPESTATUS[0]}
