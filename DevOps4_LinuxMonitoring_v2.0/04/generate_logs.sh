#!/bin/bash

# HTTP коды ответа и их значения:
# 200 - OK: запрос успешно обработан
# 201 - Created: ресурс успешно создан
# 400 - Bad Request: некорректный запрос
# 401 - Unauthorized: требуется аутентификация
# 403 - Forbidden: доступ запрещён
# 404 - Not Found: ресурс не найден
# 500 - Internal Server Error: внутренняя ошибка сервера
# 501 - Not Implemented: метод не реализован
# 502 - Bad Gateway: ошибка шлюза
# 503 - Service Unavailable: сервис недоступен

# Массивы данных
CODES=(200 201 400 401 403 404 500 501 502 503)
METHODS=(GET POST PUT PATCH DELETE)
URLS=(
    "/index.html"
    "/about.html"
    "/api/users"
    "/api/products"
    "/images/logo.png"
    "/css/style.css"
    "/js/script.js"
    "/admin/dashboard"
    "/login"
    "/register"
)

USER_AGENTS=(
    "Mozilla"
    "Chrome"
    "Opera"
    "Safari"
    "Internet Explorer"
    "Edge"
    "Googlebot"
    "Yandexbot"
    "curl"
)

generate_ip() {
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

random_element() {
    local arr=("$@")
    echo "${arr[$((RANDOM % ${#arr[@]}))]}"
}

generate_log_entry() {
    local timestamp=$1
    local ip=$(generate_ip)
    local method=$(random_element "${METHODS[@]}")
    local url=$(random_element "${URLS[@]}")
    local code=$(random_element "${CODES[@]}")
    local size=$((RANDOM % 10000 + 100))
    local agent=$(random_element "${USER_AGENTS[@]}")
    
    echo "$ip - - [$timestamp] \"$method $url HTTP/1.1\" $code $size \"-\" \"$agent\""
}

generate_daily_log() {
    local day=$1
    local log_file=$2
    local count=$((RANDOM % 901 + 100))  # 100-1000 записей
    
    > "$log_file"
    
    local base_timestamp=$(date -d "$day 00:00:00" +%s)
    local day_seconds=86400
    local interval=$((day_seconds / count))
    
    for ((i=0; i<count; i++)); do
        local current_ts=$((base_timestamp + i * interval + RANDOM % interval))
        local formatted_date=$(date -d "@$current_ts" "+%d/%b/%Y:%H:%M:%S %z")
        generate_log_entry "$formatted_date" >> "$log_file"
    done
    
    echo "Создан: $log_file ($count записей)"
}
