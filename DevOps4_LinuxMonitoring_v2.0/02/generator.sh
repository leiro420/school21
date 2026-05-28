#!/bin/bash

generate_folder_name() {
    local letters=$1
    local counter=$2
    local date=$(get_date)
    
    local name="$letters"
    while [ ${#name} -lt 5 ]; do
        name="${name}${letters}"
    done
    
    local temp=$counter
    local additional=""
    local len=${#letters}
    
    while [ $temp -gt 0 ]; do
        local idx=$(( (temp - 1) % len ))
        additional="${letters:$idx:1}${additional}"
        temp=$(( (temp - 1) / len ))
    done
    
    if [ -n "$additional" ]; then
        name="${name}${additional}"
    fi
    
    if [ ${#name} -gt 15 ]; then
        name="${name:0:15}"
    fi
    
    echo "${name}_${date}"
}

generate_file_name() {
    local letters=$1
    local counter=$2
    local date=$(get_date)
    
    local name="${letters%.*}"
    local ext="${letters##*.}"
    
    local file_name="$name"
    while [ ${#file_name} -lt 5 ]; do
        file_name="${file_name}${name}"
    done
    
    local temp=$counter
    local additional=""
    local len=${#name}
    
    while [ $temp -gt 0 ]; do
        local idx=$(( (temp - 1) % len ))
        additional="${name:$idx:1}${additional}"
        temp=$(( (temp - 1) / len ))
    done
    
    if [ -n "$additional" ]; then
        file_name="${file_name}${additional}"
    fi
    
    if [ ${#file_name} -gt 15 ]; then
        file_name="${file_name:0:15}"
    fi
    
    echo "${file_name}_${date}.${ext}"
}
