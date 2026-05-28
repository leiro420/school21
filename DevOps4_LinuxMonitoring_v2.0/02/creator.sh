#!/bin/bash

create_folder() {
    local folder_path=$1
    
    mkdir -p "$folder_path" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log_folder "$folder_path"
        return 0
    fi
    
    return 1
}

create_file() {
    local file_path=$1
    local file_size=$2
    
    local size_mb="${file_size%[Mm][Bb]}"
    
    fallocate -l "${size_mb}M" "$file_path" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        dd if=/dev/zero of="$file_path" bs=1M count=$size_mb 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        log_file "$file_path" "$file_size"
        return 0
    fi
    
    return 1
}
