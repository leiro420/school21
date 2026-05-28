#!/bin/bash

get_date() {
    date +%d%m%y
}

get_timestamp() {
    date +%s
}

get_datetime() {
    date "+%d-%m-%Y %H:%M"
}

check_free_space() {
    local free_kb=$(df / | tail -1 | awk '{print $4}')
    
    if [ $free_kb -le 1048576 ]; then
        return 1
    fi
    
    return 0
}

get_random_directory() {
    local base_dirs=("/home" "/opt" "/var" "/tmp")
    
    local available_dirs=()
    
    for dir in "${base_dirs[@]}"; do
        if [ -d "$dir" ] && [ -w "$dir" ]; then
            if [[ ! "$dir" =~ bin ]] && [[ ! "$dir" =~ sbin ]]; then
                available_dirs+=("$dir")
            fi
        fi
    done
    
    if [ ${#available_dirs[@]} -eq 0 ]; then
        return 1
    fi
    
    local random_index=$((RANDOM % ${#available_dirs[@]}))
    echo "${available_dirs[$random_index]}"
}

init_log() {
    > log.txt
}

log_folder() {
    local folder_path=$1
    echo "$folder_path/, $(get_datetime)" >> log.txt
}

log_file() {
    local file_path=$1
    local file_size=$2
    echo "$file_path, ${file_size}, $(get_datetime)" >> log.txt
}

log_statistics() {
    local start=$1
    local end=$2
    local duration=$3
    local folders=$4
    local files=$5
    
    echo "" >> log.txt
    echo "======== СТАТИСТИКА ========" >> log.txt
    echo "Время начала: $start" >> log.txt
    echo "Время окончания: $end" >> log.txt
    echo "Длительность: ${duration} секунд" >> log.txt
    echo "Создано папок: $folders" >> log.txt
    echo "Создано файлов: $files" >> log.txt
}
