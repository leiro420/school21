#!/bin/bash

. ./generate_logs.sh

main() {
    mkdir -p logs
    
    # Генерируем логи за последние 5 дней
    for i in {1..5}; do
        local date=$(date -d "$i days ago" "+%Y-%m-%d")
        generate_daily_log "$date" "logs/access_log_$i.log"
    done
    
    echo ""
    echo "Генерация завершена! Логи находятся в папке logs/"
}

main
