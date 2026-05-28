#!/bin/bash

get_date_format() {
    date +%d%m%y
}

get_free_space_mb() {
    df / | grep -v Filesystem | awk '{print $4}'
}

check_free_space() {
    local free_kb=$(get_free_space_mb)
    local min_kb=1048576  # 1GB в KB
    
    if [ "$free_kb" -le "$min_kb" ]; then
        echo "Осталось менее 1GB свободного места!"
        echo "Свободно: $(($free_kb / 1024)) MB"
        return 1
    fi
    
    return 0
}

generate_folder_name() {
    local letters=$1
    local counter=$2
    local min_length=4
    local date_suffix=$(get_date_format)
    
    local name="$letters"
    
    while [ ${#name} -lt $min_length ]; do
        name="${name}${letters}"
    done
    
    local extra_chars=$((counter % ${#letters}))
    for ((k=0; k<extra_chars; k++)); do
        local char_index=$((k % ${#letters}))
        name="${name}${letters:$char_index:1}"
    done
    
    local max_len=$((min_length + 4))
    if [ ${#name} -gt $max_len ]; then
        name="${name:0:$max_len}"
    fi
    
    echo "${name}_${date_suffix}"
}

generate_file_name() {
    local letters=$1
    local counter=$2
    local min_length=4
    local date_suffix=$(get_date_format)
    
    local name_letters="${letters%.*}"
    local ext_letters="${letters##*.}"
    
    local name="$name_letters"
    while [ ${#name} -lt $min_length ]; do
        name="${name}${name_letters}"
    done
    
    local extra_chars=$((counter % ${#name_letters}))
    for ((k=0; k<extra_chars; k++)); do
        local char_index=$((k % ${#name_letters}))
        name="${name}${name_letters:$char_index:1}"
    done
    
    local max_len=$((min_length + 5))
    if [ ${#name} -gt $max_len ]; then
        name="${name:0:$max_len}"
    fi
    
    echo "${name}_${date_suffix}.${ext_letters}"
}

create_file_with_size() {
    local filepath=$1
    local size_kb=$2
    
    fallocate -l "${size_kb}K" "$filepath" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        dd if=/dev/zero of="$filepath" bs=1K count=$size_kb 2>/dev/null
    fi
}

log_folder() {
    local folder_path=$1
    local creation_date=$(date "+%d-%m-%Y %H:%M:%S")
    
    echo "$folder_path/, $creation_date" >> ./log.txt
}

log_file() {
    local file_path=$1
    local file_size=$2
    local creation_date=$(date "+%d-%m-%Y %H:%M:%S")
    
    echo "$file_path, $creation_date, ${file_size}KB" >> ./log.txt
}
