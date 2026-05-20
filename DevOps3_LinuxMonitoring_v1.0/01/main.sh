#!/bin/bash

dir=$(dirname "$0")

. "$dir/check.sh"

if [ $# -ne 1 ]; then
	echo "ERROR: укажите только 1 параметр"
	exit 1
fi

parametr="$1"

if number "$parametr"; then
	echo "ERROR: нельзя ввести числа, только текст"
	exit 1
fi

echo "$parametr"
