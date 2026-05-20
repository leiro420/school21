#!/bin/bash

hostname=$(hostname)
timezone="$(timedatectl | grep 'Time zone' | awk '{print $3}') $(timedatectl | grep 'Universal time' | awk '{print $6}') $(timedatectl | grep 'Local time' | awk '{print $6}')"
user=$(whoami)
os="$(lsb_release -ds)"
current_date=$(date +"%d %B %Y, %H:%M:%S")
uptime_human=$(uptime -p | sed 's/up //')
uptime_sec=$(awk '{print int($1)}' /proc/uptime)
ip=$(hostname -I | awk '{print $1}')
mask=$(ifconfig | grep $ip | awk '/netmask/ {print $4}')
gateway=$(ip r | grep default | awk '{print $3}')
ram_total=$(free | awk '/Mem/ {printf "%.3f", $2/1024/1024}')
ram_used=$(free | awk '/Mem/ {printf "%.3f", $3/1024/1024}')
ram_free=$(free | awk '/Mem/ {printf "%.3f", $4/1024/1024}')
disk_total=$(df / | awk 'NR==2{printf "%.2f", $2/1024}')
disk_used=$(df / | awk 'NR==2{printf "%.2f", $3/1024}')
disk_free=$(df / | awk 'NR==2{printf "%.2f", $4/1024}')

echo "HOSTNAME = $hostname"
echo "TIMEZONE = $timezone"
echo "USER = $user"
echo "OS = $os"
echo "DATE = $current_date"
echo "UPTIME = $uptime_human"
echo "UPTIME_SEC = $uptime_sec"
echo "IP = $ip"
echo "MASK = $mask"
echo "GATEWAY = $gateway"
echo "RAM TOTAL = $ram_total GB"
echo "RAM USED = $ram_used GB"
echo "RAM FREE = $ram_free GB"
echo "SPACE ROOT = $disk_total MB"
echo "SPACE ROOT USED = $disk_used MB"
echo "SPACE ROOT FREE = $disk_free MB"

echo
read -p "Do you want to save the data into a file? (Y/N): " ans
if [[ "$ans" == "Y" || "$ans" == "y" ]]; then
	filename="$(date +"%d_%m_%y_%H_%M_%S").status"
	{
		echo "HOSTNAME = $hostname"
		echo "TIMEZONE = $timezone"
		echo "USER = $user"
		echo "OS = $os"
		echo "DATE = $current_date"
		echo "UPTIME = $uptime_human"
		echo "UPTIME SEC = $uptime_sec"
		echo "IP = $ip"
		echo "MASK = $mask"
		echo "GATEWAY = $gateway"
		echo "RAM TOTAL = $ram_total GB"
		echo "RAM USED = $ram_used GB"
		echo "RAM FREE = $ram_free GB"
		echo "SPACE ROOT = $disk_total MB"
		echo "SPACE ROOT USED = $disk_used MB"
		echo "SPACE ROOT FREE = $disk_free MB"
	} > "$filename"
	echo "The file was successful write to $filename"
else
	echo "The file was not write"
fi
