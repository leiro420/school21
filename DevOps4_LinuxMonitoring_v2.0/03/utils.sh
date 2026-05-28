#!/bin/bash

validate_datetime() {
    local datetime=$1
    
    if [[ ! "$datetime" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
        return 1
    fi
    
    date -d "$datetime" >/dev/null 2>&1
    return $?
}

validate_mask() {
    local mask=$1
    
    if [[ ! "$mask" =~ ^[a-zA-Z]+_[0-9]{6}$ ]]; then
        return 1
    fi
    
    return 0
}
