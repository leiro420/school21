#!/bin/bash

# Путь к логам из Part 4
LOGS_DIR="../04/logs"

# Проверка существования директории с логами
check_logs() {
    if [ ! -d "$LOGS_DIR" ]; then
        echo "Ошибка: Директория с логами не найдена: $LOGS_DIR"
        echo "Сначала запустите генератор логов из Part 4!"
        exit 1
    fi
    
    if [ -z "$(ls -A $LOGS_DIR/*.log 2>/dev/null)" ]; then
        echo "Ошибка: Файлы логов не найдены в $LOGS_DIR"
        echo "Сначала запустите генератор логов из Part 4!"
        exit 1
    fi
}

sort_by_response_code() {
    echo "1. Сортировка по коду ответа завершена"
    echo "Смотри файл log_1.txt"
    
    cat $LOGS_DIR/*.log | awk '{print $9, $0}' | sort -n | awk '{$1=""; print substr($0,2)}' > log_1.txt
}

unique_ips() {
    echo "2. Сортировка по уникальным IP-адресам завершена"
    echo "Смотри файл log_2.txt"
    
    cat $LOGS_DIR/*.log | awk '{print $1}' | sort -u > log_2.txt
    echo -e "\n\nВсего уникальных IP:" >> log_2.txt
    cat $LOGS_DIR/*.log | awk '{print $1}' | sort -u | wc -l >> log_2.txt
}

error_requests() {
    echo "3. Сортировка по запросам с ошибками (4xx, 5xx) завершена"
    echo "Смотри файл log_3.txt"
    
    cat $LOGS_DIR/*.log | awk '$9 >= 400 && $9 < 600 {print}' > log_3.txt
    echo -e "\n\nВсего ошибочных запросов:" >> log_3.txt
    cat $LOGS_DIR/*.log | awk '$9 >= 400 && $9 < 600' | wc -l >> log_3.txt
}

unique_error_ips() {
    echo "  4. Сортировка по уникальным IP с ошибочными запросами завершена"
    echo "Смотри файл log_4.txt"
    
    cat $LOGS_DIR/*.log | awk '$9 >= 400 && $9 < 600 {print $1}' | sort -u > log_4.txt
    echo -e "\n\nВсего уникальных IP с ошибками:" >> log_4.txt
    cat $LOGS_DIR/*.log | awk '$9 >= 400 && $9 < 600 {print $1}' | sort -u | wc -l >> log_4.txt
}

show_usage() {
    echo "Параметры:"
    echo "  1 - Все записи, отсортированные по коду ответа"
    echo "  2 - Все уникальные IP"
    echo "  3 - Все запросы с ошибками (4xx, 5xx)"
    echo "  4 - Уникальные IP с ошибочными запросами"
    echo ""
    echo "Примеры:"
    echo "  $0 1"
    echo "  $0 2"
    echo "  $0 3"
    echo "  $0 4"
}
