#!/bin/bash

validate_params() {
    local folder_letters=$1
    local file_letters=$2
    local file_size=$3
    
    if [ ${#folder_letters} -gt 7 ]; then
        echo "Ошибка: буквы для папок - максимум 7 символов"
        return 1
    fi
    
    if ! [[ "$folder_letters" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: буквы папок - только английские буквы"
        return 1
    fi
    
    if [[ ! "$file_letters" =~ \. ]]; then
        echo "Ошибка: формат файла должен быть: имя.расширение"
        return 1
    fi
    
    local name="${file_letters%.*}"
    local ext="${file_letters##*.}"
    
    if [ ${#name} -gt 7 ]; then
        echo "Ошибка: имя файла - максимум 7 символов"
        return 1
    fi
    
    if [ ${#ext} -gt 3 ]; then
        echo "Ошибка: расширение - максимум 3 символа"
        return 1
    fi
    
    if ! [[ "$name" =~ ^[a-zA-Z]+$ ]] || ! [[ "$ext" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: имя и расширение - только английские буквы"
        return 1
    fi
    
    if ! [[ "$file_size" =~ ^[0-9]+[Mm][Bb]$ ]]; then
        echo "Ошибка: размер должен быть в формате: 50Mb"
        return 1
    fi
    
    local size_mb="${file_size%[Mm][Bb]}"
    
    if [ $size_mb -gt 100 ]; then
        echo "Ошибка: размер не должен превышать 100Mb"
        return 1
    fi
    
    return 0
}
