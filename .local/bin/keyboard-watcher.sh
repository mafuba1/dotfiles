#!/bin/bash

pid=$(pgrep -n dwmblocks)
[ -z "$pid" ] && exit 1  # dwmblocks не найден — выходим

xkb-switch -W | while read -r layout; do
    # Можно выводить в лог для отладки:
    # echo "Layout changed to: $layout" >> /tmp/kbd.log

    # Отправляем сигнал для обновления блока с сигналом 1
    pkill -RTMIN+1 -P "$pid" 2>/dev/null || kill -RTMIN+1 "$pid" 2>/dev/null
done

