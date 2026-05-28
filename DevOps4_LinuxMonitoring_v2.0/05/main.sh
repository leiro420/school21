#!/bin/bash

# Импорт утилит
. ./utils.sh

# Главная функция
main() {
    # Проверка параметра
    if [ $# -ne 1 ]; then
        show_usage
        exit 1
    fi
    
    # Проверка существования логов
    check_logs
    
    # Выполнение функции в зависимости от параметра
    case $1 in
        1)
            sort_by_response_code
            ;;
        2)
            unique_ips
            ;;
        3)
            error_requests
            ;;
        4)
            unique_error_ips
            ;;
        *)
            echo "Ошибка: Неверный параметр '$1'"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Запуск программы
main "$@"
