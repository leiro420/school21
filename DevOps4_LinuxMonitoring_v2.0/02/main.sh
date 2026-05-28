#!/bin/bash

. ./validation.sh
. ./utils.sh
. ./generator.sh
. ./creator.sh

if [ $# -ne 3 ]; then
    echo "Ошибка: нужно 3 параметра"
    echo "Пример: $0 az abc.txt 50Mb"
    exit 1
fi

validate_params "$1" "$2" "$3"
if [ $? -ne 0 ]; then
    exit 1
fi

FOLDER_LETTERS=$1
FILE_LETTERS=$2
FILE_SIZE=$3

init_log
START_TIME=$(get_timestamp)
START_TIME_STR="$(get_datetime):$(date +%S)"

FOLDERS_CREATED=0
FILES_CREATED=0

for folder_num in $(seq 1 100); do
    
    if ! check_free_space; then
        echo "Работа скрипта завершена. Осталось менее 1GB свободного места"
        break
    fi
    
    TARGET_DIR=$(get_random_directory)
    
    if [ -z "$TARGET_DIR" ]; then
        echo "Не удалось найти доступную директорию"
        continue
    fi
    
    FOLDER_NAME=$(generate_folder_name "$FOLDER_LETTERS" "$folder_num")
    FOLDER_PATH="${TARGET_DIR}/${FOLDER_NAME}"
    
    create_folder "$FOLDER_PATH"
    
    if [ $? -eq 0 ]; then
        FOLDERS_CREATED=$((FOLDERS_CREATED + 1))
        
        FILES_IN_FOLDER=$((RANDOM % 100 + 1))
        
        for file_num in $(seq 1 $FILES_IN_FOLDER); do
            
            if ! check_free_space; then
                echo "Работа скрипта завершена. Осталось менее 1GB свободного места"
                break 2
            fi
            
            FILE_NAME=$(generate_file_name "$FILE_LETTERS" "$file_num")
            FILE_PATH="${FOLDER_PATH}/${FILE_NAME}"
            
            create_file "$FILE_PATH" "$FILE_SIZE"
            
            if [ $? -eq 0 ]; then
                FILES_CREATED=$((FILES_CREATED + 1))
            fi
        done
    fi
    
done

END_TIME=$(get_timestamp)
END_TIME_STR="$(get_datetime):$(date +%S)"
DURATION=$((END_TIME - START_TIME))

echo "=========================================="
echo "Завершено!"
echo "Время начала: $START_TIME_STR"
echo "Время окончания: $END_TIME_STR"
echo "Общее время: ${DURATION} секунд"
echo "Создано папок: $FOLDERS_CREATED"
echo "Создано файлов: $FILES_CREATED"
echo "=========================================="

log_statistics "$START_TIME_STR" "$END_TIME_STR" "$DURATION" "$FOLDERS_CREATED" "$FILES_CREATED"
