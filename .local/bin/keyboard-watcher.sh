#!/bin/bash

pid=$(pgrep dwmblocks)

xkb-switch -W | while read -r layout; do
    # Можно выводить в лог для отладки:
    # echo "Layout changed to: $layout" >> /tmp/kbd.log

    # Отправляем сигнал для обновления блока с сигналом 1
    [ -n "$pid" ] && kill -RTMIN+1 "$pid"
done

