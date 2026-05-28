#!/bin/bash

. ./validation.sh
. ./generator.sh
. ./utils.sh

if [ $# -ne 6 ]; then
    echo "Ошибка: Необходимо 6 параметров"
    echo "Использование: $0 <путь> <кол-во папок> <буквы папок> <кол-во файлов> <буквы.расширение> <размер>"
    echo "Пример: $0 /opt/test 4 az 5 az.az 3kb"
    exit 1
fi

ABSOLUTE_PATH=$1
FOLDER_COUNT=$2
FOLDER_LETTERS=$3
FILE_COUNT=$4
FILE_LETTERS=$5
FILE_SIZE=$6

validate_all_params "$ABSOLUTE_PATH" "$FOLDER_COUNT" "$FOLDER_LETTERS" "$FILE_COUNT" "$FILE_LETTERS" "$FILE_SIZE"

if [ $? -ne 0 ]; then
    exit 1
fi

> ./log.txt

generate_structure "$ABSOLUTE_PATH" "$FOLDER_COUNT" "$FOLDER_LETTERS" "$FILE_COUNT" "$FILE_LETTERS" "$FILE_SIZE"

echo "Лог сохранён в: ./log.txt"
