#!/bin/bash

start_time=$(date +%s.%N)

if [ "$#" -ne 1 ]; then
  echo "ERROR: требуется указать путь к директории с завершающим символом'/'"
  exit 1
fi

dir="$1"
if [[ "${dir: -1}" != "/" ]]; then
  echo "ERROR: путь должен заканчиваться символом '/'"
  exit 1
fi

if [ ! -d "$dir" ]; then
  echo "ERROR: такой директории нет"
  exit 1
fi

total_folders=$(find "$dir" -type d 2>/dev/null | wc -l)
echo -e "\e[41m\e[97mTotal number of folders (including all nested ones) = $total_folders\e[0m"
echo ""

echo -e "\e[41m\e[97mTOP 5 folders of maximum size arranged in descending order (path and size):\e[0m"
du -h "$dir"*/ 2>/dev/null | sort -hr | head -n 5 | awk '{printf "%d - %s, %s\n", NR, $2, $1}'
echo ""

total_files=$(find "$dir" -type f 2>/dev/null | wc -l)
echo -e "\e[41m\e[97mTotal number of files = $total_files\e[0m"
echo ""

conf_files=$(find "$dir" -type f -name "*.conf" 2>/dev/null | wc -l)
text_files=$(find "$dir" -type f -exec file --mime-type {} + 2>/dev/null | grep 'text/' | wc -l)
exec_files=$(find "$dir" -type f -executable 2>/dev/null | wc -l)
log_files=$(find "$dir" -type f -name "*.log" 2>/dev/null | wc -l)
archive_files=$(find "$dir" -type f \( -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.xz" -o -name "*.zip" -o -name "*.7z" \) 2>/dev/null | wc -l)
symlinks=$(find "$dir" -type l 2>/dev/null | wc -l)

echo -e "\e[41m\e[97mNumber of:\e[0m"
echo "Configuration files (with the .conf extension) = $conf_files"
echo "Text files = $text_files"
echo "Executable files = $exec_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $archive_files"
echo "Symbolic links = $symlinks"
echo ""

echo -e "\e[41m\e[97mTOP 10 files of maximum size arranged in descending order (path, size and type):\e[0m"
find "$dir" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 10 | awk '{
  filepath = $2
  size = $1
  
  n = split(filepath, parts, "/")
  filename = parts[n]
  
  if (match(filename, /\.[^.]+$/)) {
    extension = substr(filename, RSTART + 1)
  } else {
    extension = "file"
  }
  
  printf "%d - %s, %s, %s\n", NR, filepath, size, extension
}'
echo ""

echo -e "\e[41m\e[97mTOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):\e[0m"
find "$dir" -type f -executable -exec du -h {} + 2>/dev/null | sort -hr | head -n 10 | awk '{
  filepath = $2
  size = $1
  cmd = "md5sum \"" filepath "\" 2>/dev/null"
  cmd | getline result
  close(cmd)
  split(result, arr, " ")
  md5hash = arr[1]
  
  printf "%d - %s, %s, %s\n", NR, filepath, size, md5hash
}'
echo ""

end_time=$(date +%s.%N)
duration=$(echo "$end_time - $start_time" | bc)
duration=$(printf "%.1f" "$duration")
echo -e "\e[41m\e[97mScript execution time (in seconds) = $duration\e[0m"
