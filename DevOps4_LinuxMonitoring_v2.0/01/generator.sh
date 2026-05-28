#!/bin/bash

generate_structure() {
    local base_path=$1
    local folder_count=$2
    local folder_letters=$3
    local file_count=$4
    local file_letters=$5
    local file_size=$6
    
    base_path="${base_path%/}"
    
    local size_kb="${file_size%[kK][bB]}"
    
    local folders_created=0
    local files_created=0
    
    for (( i=1; i<=folder_count; i++ )); do
        
        if ! check_free_space; then
            echo "Остановка: недостаточно свободного места (менее 1GB)"
            break
        fi
        
        local folder_name=$(generate_folder_name "$folder_letters" "$i")
        local folder_path="${base_path}/${folder_name}"
        
        if [ -d "$folder_path" ]; then
            folder_name="${folder_name}_$(date +%H%M%S)"
            folder_path="${base_path}/${folder_name}"
        fi
        
        mkdir -p "$folder_path"
        
        if [ $? -eq 0 ]; then
            folders_created=$((folders_created + 1))
            log_folder "$folder_path"
            
            for (( j=1; j<=file_count; j++ )); do
                
                if ! check_free_space; then
                    echo "Остановка: недостаточно свободного места (менее 1GB)"
                    break 2
                fi
                
                local file_name=$(generate_file_name "$file_letters" "$j")
                local file_path="${folder_path}/${file_name}"
                
                if [ -f "$file_path" ]; then
                    local timestamp=$(date +%N)
                    local name_without_ext="${file_name%.*}"
                    local ext="${file_name##*.}"
                    file_name="${name_without_ext}_${timestamp}.${ext}"
                    file_path="${folder_path}/${file_name}"
                fi
                
                create_file_with_size "$file_path" "$size_kb"
                
                if [ $? -eq 0 ]; then
                    files_created=$((files_created + 1))
                    log_file "$file_path" "$size_kb"
                else
                    echo "Ошибка при создании файла: $file_name"
                fi
            done
        else
            echo "Ошибка при создании папки: $folder_path"
        fi
    done
}
