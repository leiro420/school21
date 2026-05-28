#!/bin/bash

validate_path() {
    local path=$1
    
    if [[ ! "$path" =~ ^/ ]]; then
        echo "Ошибка: Путь должен быть абсолютным (начинаться с /)"
        return 1
    fi
    
    if [ ! -d "$path" ]; then
        echo "Ошибка: Директория $path не существует"
        return 1
    fi
    
    if [ ! -w "$path" ]; then
        echo "Ошибка: Нет прав на запись в директорию $path"
        return 1
    fi
    
    return 0
}

validate_folder_count() {
    local count=$1
    
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: Количество папок должно быть числом"
        return 1
    fi
    
    if [ "$count" -lt 1 ] || [ "$count" -gt 100 ]; then
        echo "Ошибка: Количество папок должно быть от 1 до 100"
        return 1
    fi
    
    return 0
}

validate_folder_letters() {
    local letters=$1
    
    if [ ${#letters} -gt 7 ]; then
        echo "Ошибка: Список букв для папок не должен превышать 7 символов"
        return 1
    fi
    
    if ! [[ "$letters" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: Буквы для папок должны быть только английскими"
        return 1
    fi
    
    if [ ${#letters} -lt 1 ]; then
        echo "Ошибка: Нужен хотя бы 1 символ для названия папок"
        return 1
    fi
    
    return 0
}

validate_file_count() {
    local count=$1
    
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: Количество файлов должно быть числом"
        return 1
    fi
    
    if [ "$count" -lt 1 ]; then
        echo "Ошибка: Количество файлов должно быть минимум 1"
        return 1
    fi
    
    return 0
}

validate_file_letters() {
    local letters=$1
    
    if [[ ! "$letters" =~ \. ]]; then
        echo "Ошибка: Формат должен быть: буквы.расширение (например, abc.txt)"
        return 1
    fi
    
    local name="${letters%.*}"
    local ext="${letters##*.}"
    
    if [ ${#name} -gt 7 ]; then
        echo "Ошибка: Имя файла не должно превышать 7 символов"
        return 1
    fi
    
    if [ ${#ext} -gt 3 ]; then
        echo "Ошибка: Расширение файла не должно превышать 3 символа"
        return 1
    fi
    
    if ! [[ "$name" =~ ^[a-zA-Z]+$ ]] || ! [[ "$ext" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: Имя и расширение файла должны содержать только английские буквы"
        return 1
    fi
    
    return 0
}

validate_file_size() {
    local size=$1
    
    if ! [[ "$size" =~ ^[0-9]+[kK][bB]$ ]]; then
        echo "Ошибка: Размер должен быть в формате: число+kb (например, 3kb)"
        return 1
    fi
    
    local num="${size%[kK][bB]}"
    
    if [ "$num" -lt 1 ] || [ "$num" -gt 100 ]; then
        echo "Ошибка: Размер файла должен быть от 1kb до 100kb"
        return 1
    fi
    
    return 0
}

validate_all_params() {
    local path=$1
    local folder_count=$2
    local folder_letters=$3
    local file_count=$4
    local file_letters=$5
    local file_size=$6
    
    validate_path "$path" || return 1
    validate_folder_count "$folder_count" || return 1
    validate_folder_letters "$folder_letters" || return 1
    validate_file_count "$file_count" || return 1
    validate_file_letters "$file_letters" || return 1
    validate_file_size "$file_size" || return 1
    return 0
}
