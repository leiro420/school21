#!/bin/bash

if [ $# -ne 4 ]; then
  echo "ERROR: нужно 4 параметра цвета от 1 до 6
Например: 
$0 1 2 3 4"
  exit 1
fi

bg_name=$1
fg_name=$2
bg_value=$3
fg_value=$4

for c in "$bg_name" "$fg_name" "$bg_value" "$fg_value"
do
  if ! [[ "$c" =~ ^[1-6]$ ]]; then
    echo "ERROR: параметры должны быть числами от 1 до 6"
    exit 1
  fi
done

if [ "$bg_name" -eq "$fg_name" ]; then
  echo "ERROR: фон и цвет текста названий не должны совпадать"
  exit 1
fi

if [ "$bg_value" -eq "$fg_value" ]; then
  echo "ERROR: фон и цвет текста значений не должны совпадать"
  exit 1
fi

color_code() {
  case $1 in
    1) echo "47" ;; # white bg
    2) echo "41" ;; # red bg
    3) echo "42" ;; # green bg
    4) echo "44" ;; # blue bg
    5) echo "45" ;; # purple bg
    6) echo "40" ;; # black bg
  esac
}

font_code() {
  case $1 in
    1) echo "97" ;; # white fg
    2) echo "31" ;; # red fg
    3) echo "32" ;; # green fg
    4) echo "34" ;; # blue fg
    5) echo "35" ;; # purple fg
    6) echo "30" ;; # black fg
  esac
}

bg_name_code=$(color_code "$bg_name")
fg_name_code=$(font_code "$fg_name")
bg_value_code=$(color_code "$bg_value")
fg_value_code=$(font_code "$fg_value")


hostname=$(hostname)
timezone="$(timedatectl | grep 'Time zone' | awk '{print $3}') $(timedatectl | grep 'Universal time' | awk '{print $6}') $(timedatectl | grep 'Local time' | awk '{print $6}')"
user=$(whoami)
os=$(lsb_release -ds)
current_date=$(date +"%d %B %Y, %H:%M:%S")
uptime_human=$(uptime -p | sed 's/up //')
uptime_sec=$(awk '{print int($1)}' /proc/uptime)
ip=$(hostname -I | awk '{print $1}')
mask=$(ifconfig | grep "$ip" | awk '/netmask/ {print $4}')
gateway=$(ip r | grep default | awk '{print $3}')
ram_total=$(free | awk '/Mem/ {printf "%.3f", $2/1024/1024}')
ram_used=$(free | awk '/Mem/ {printf "%.3f", $3/1024/1024}')
ram_free=$(free | awk '/Mem/ {printf "%.3f", $4/1024/1024}')
disk_total=$(df / | awk 'NR==2{printf "%.2f", $2/1024}')
disk_used=$(df / | awk 'NR==2{printf "%.2f", $3/1024}')
disk_free=$(df / | awk 'NR==2{printf "%.2f", $4/1024}')

print_colored() {
  local bg=$1
  local fg=$2
  local text=$3
  echo -e "\e[${bg}m\e[${fg}m${text}\e[0m"
}

print_line() {
  local name=$1
  local value=$2
  local name_colored=$(print_colored "$bg_name_code" "$fg_name_code" "$name")
  local value_colored=$(print_colored "$bg_value_code" "$fg_value_code" "$value")
  echo -e "${name_colored} = ${value_colored}"
}

print_line "HOSTNAME" "$hostname"
print_line "TIMEZONE" "$timezone"
print_line "USER" "$user"
print_line "OS" "$os"
print_line "DATE" "$current_date"
print_line "UPTIME" "$uptime_human"
print_line "UPTIME_SEC" "$uptime_sec"
print_line "IP" "$ip"
print_line "MASK" "$mask"
print_line "GATEWAY" "$gateway"
print_line "RAM TOTAL GB" "$ram_total"
print_line "RAM USED GB" "$ram_used"
print_line "RAM FREE GB" "$ram_free"
print_line "SPACE ROOT MB" "$disk_total"
print_line "SPACE ROOT USED MB" "$disk_used"
print_line "SPACE ROOT FREE MB" "$disk_free"

