#!/bin/bash

. ./clean_by_log.sh
. ./clean_by_date.sh
. ./clean_by_mask.sh
. ./utils.sh

if [ $# -ne 1 ]; then
    echo "Ошибка: необходим 1 параметр"
    echo "Использование: $0 <метод>"
    echo ""
    echo "Методы очистки:"
    echo "  1 - По лог-файлу"
    echo "  2 - По дате и времени создания"
    echo "  3 - По маске имени (символы, подчёркивание, дата)"
    exit 1
fi

METHOD=$1

if [[ ! "$METHOD" =~ ^[1-3]$ ]]; then
    echo "Ошибка: метод должен быть 1, 2 или 3"
    exit 1
fi

case $METHOD in
    1)
        echo "Метод: Очистка по лог-файлу"
        echo ""
        clean_by_log
        ;;
    2)
        echo "Метод: Очистка по дате и времени"
        echo ""
        clean_by_date
        ;;
    3)
        echo "Метод: Очистка по маске имени"
        echo ""
        clean_by_mask
        ;;
esac
