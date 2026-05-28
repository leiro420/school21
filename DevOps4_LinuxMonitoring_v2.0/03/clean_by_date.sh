#!/bin/bash

clean_by_date() {
    local log="../02/log.txt"
    [ ! -f "$log" ] && return 1

    echo "Введите начальную дату и время (DD-MM-YYYY HH:MM):"
    read -p "> " start_input

    echo "Введите конечную дату и время (DD-MM-YYYY HH:MM):"
    read -p "> " end_input

    local s=$(echo "$start_input" | awk -F'[-: ]' '{print $3$2$1$4$5}')
    local e=$(echo "$end_input" | awk -F'[-: ]' '{print $3$2$1$4$5}')

    local count=0

    while IFS=, read -r path rest; do
        [[ "$path" =~ /$ ]] || continue
        [[ "$rest" == *,* ]] && continue

        path=$(echo "$path" | xargs)
        path="${path%/}"

        local date_time=$(echo "$rest" | xargs)
        local t=$(echo "$date_time" | awk -F'[-: ]' '{print $3$2$1$4$5}')
        [ -z "$t" ] && continue

        if [ "$t" -ge "$s" ] && [ "$t" -le "$e" ]; then
            if [ -d "$path" ]; then
                rm -rf "$path" 2>/dev/null
                if [ $? -eq 0 ]; then
                    count=$((count+1))
                fi
            fi
        fi

    done < "$log"
}

