#!/bin/bash
# Автоматический мониторинг видеоконтента и управление прозрачностью

LOG_FILE="/tmp/video-monitor.log"
PIDFILE="/tmp/video-monitor.pid"

# Функция логирования
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Функция установки прозрачности для окна
set_opacity() {
    local window_id="$1"
    local opacity="$2"
    
    if [ -n "$window_id" ] && [ -n "$opacity" ]; then
        xprop -id "$window_id" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$opacity" 2>/dev/null
        log_message "Установлена прозрачность $opacity для окна $window_id"
    fi
}

# Функция удаления прозрачности (делает окно непрозрачным)
remove_opacity() {
    local window_id="$1"
    
    if [ -n "$window_id" ]; then
        xprop -id "$window_id" -remove _NET_WM_WINDOW_OPACITY 2>/dev/null
        log_message "Удалена прозрачность для окна $window_id (окно непрозрачное)"
    fi
}

# Получение списка окон браузеров
get_browser_windows() {
    xdotool search --class "firefox|google-chrome|chromium|Google-chrome|librewolf" 2>/dev/null
}

# Проверка высокой нагрузки CPU для браузеров (индикатор видео)
check_video_activity() {
    # Проверяем процессы браузеров с высоким CPU (>25%)
    ps aux | grep -E "(firefox|chrome|chromium|librewolf)" | grep -v grep | awk '$3 > 25.0 {print $2, $3, $11}' | head -5
}

# Проверка полноэкранного режима
check_fullscreen() {
    local window_id="$1"
    xprop -id "$window_id" _NET_WM_STATE 2>/dev/null | grep -q "_NET_WM_STATE_FULLSCREEN"
}

# Проверка заголовков окон на видеоплатформы
check_video_titles() {
    get_browser_windows | while read window_id; do
        if [ -n "$window_id" ]; then
            title=$(xdotool getwindowname "$window_id" 2>/dev/null)
            if echo "$title" | grep -q -i -E "(youtube|netflix|twitch|prime video|disney|hbo|vimeo|zoom|meet|teams)"; then
                echo "$window_id:$title"
            fi
        fi
    done
}

# Основной цикл мониторинга
main_loop() {
    log_message "Запуск мониторинга видеоконтента"
    
    # Сохраняем состояние прозрачности
    declare -A window_states
    
    while true; do
        # Получаем все окна браузеров
        browser_windows=$(get_browser_windows)
        
        # Проверяем видеоактивность по CPU
        video_processes=$(check_video_activity)
        
        # Проверяем заголовки окон
        video_titles=$(check_video_titles)
        
        for window_id in $browser_windows; do
            if [ -n "$window_id" ]; then
                should_be_opaque=false
                reason=""
                
                # Проверка 1: Полноэкранный режим
                if check_fullscreen "$window_id"; then
                    should_be_opaque=true
                    reason="fullscreen"
                fi
                
                # Проверка 2: Видео в заголовке
                if echo "$video_titles" | grep -q "^$window_id:"; then
                    should_be_opaque=true
                    reason="video_title"
                fi
                
                # Проверка 3: Высокая нагрузка CPU
                if [ -n "$video_processes" ]; then
                    # Получаем PID процесса окна
                    window_pid=$(xdotool getwindowpid "$window_id" 2>/dev/null)
                    if echo "$video_processes" | grep -q "^$window_pid "; then
                        should_be_opaque=true
                        reason="high_cpu"
                    fi
                fi
                
                # Применяем изменения
                current_state="${window_states[$window_id]:-transparent}"
                
                if [ "$should_be_opaque" = true ] && [ "$current_state" != "opaque" ]; then
                    remove_opacity "$window_id"
                    window_states[$window_id]="opaque"
                    log_message "Окно $window_id стало непрозрачным ($reason)"
                    
                elif [ "$should_be_opaque" = false ] && [ "$current_state" != "transparent" ]; then
                    # Возвращаем прозрачность (85% = 0xd9ffffff)
                    set_opacity "$window_id" "0xd9ffffff"
                    window_states[$window_id]="transparent"
                    log_message "Окно $window_id стало прозрачным"
                fi
            fi
        done
        
        # Пауза между проверками (можно уменьшить для более быстрой реакции)
        sleep 3
    done
}

# Функция остановки
stop_monitor() {
    if [ -f "$PIDFILE" ]; then
        local pid=$(cat "$PIDFILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            log_message "Мониторинг остановлен (PID: $pid)"
        fi
        rm -f "$PIDFILE"
    fi
}

# Функция запуска
start_monitor() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        echo "Мониторинг уже запущен (PID: $(cat "$PIDFILE"))"
        exit 1
    fi
    
    # Запускаем в фоне
    main_loop &
    echo $! > "$PIDFILE"
    echo "Мониторинг запущен (PID: $!)"
    log_message "Мониторинг запущен (PID: $!)"
}

# Обработка аргументов
case "${1:-start}" in
    start)
        start_monitor
        ;;
    stop)
        stop_monitor
        ;;
    restart)
        stop_monitor
        sleep 1
        start_monitor
        ;;
    status)
        if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            echo "Мониторинг активен (PID: $(cat "$PIDFILE"))"
        else
            echo "Мониторинг не запущен"
        fi
        ;;
    log)
        tail -f "$LOG_FILE"
        ;;
    *)
        echo "Использование: $0 {start|stop|restart|status|log}"
        exit 1
        ;;
esac
