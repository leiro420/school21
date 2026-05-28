#!/bin/bash

clean_by_mask() {
    local log="../02/log.txt"
    [ ! -f "$log" ] && return 1

    echo "Введите маску для поиска (например: az_291025):"
    read -p "> " m
    [ -z "$m" ] && return 1

    local date_part=""
    if [[ "$m" == *_* ]]; then
        date_part="${m##*_}"
    else
        date_part="$m"
    fi

    local count=0

    while IFS=, read -r path rest; do
        [[ "$path" =~ /$ ]] || continue
        [[ "$rest" == *,* ]] && continue
        path=$(echo "$path" | xargs)
        path="${path%/}"

        if [[ "$path" == *"$date_part"* ]]; then
            if [ -d "$path" ]; then
                rm -rf "$path" 2>/dev/null
                if [ $? -eq 0 ]; then
                    count=$((count+1))
                fi
            fi
        fi

    done < "$log"
}
