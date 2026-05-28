#!/bin/bash

clean_by_log() {
    local log="../02/log.txt"
    [ ! -f "$log" ] && return 1
    
    local count=0
    
    while IFS=, read -r path rest; do
        [[ "$path" =~ /$ ]] || continue
        
        [[ "$rest" == *,* ]] && continue
        
        path=$(echo "$path" | xargs)
        path="${path%/}"
        
        if [ -d "$path" ]; then
            rm -rf "$path" 2>/dev/null
            if [ $? -eq 0 ]; then
                count=$((count+1))
            fi
        fi
        
    done < "$log"
}
