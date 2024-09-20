#!/bin/bash

if [ -z "$1" ]; then
    echo -e "Usage: $0 <base_url>\nExample: $0 https://cdn.onepiecechapters.com/file/CDN-M-A-N/jjk_shin_001.png"
    exit 1
fi 

sanitize_input() {
    echo "$1" | sed 's/[^a-zA-Z0-9_-]//g'
}

read -p "Enter manga name: "
manga_name=$(sanitize_input "$REPLY")
read -p "Enter chapter number: "
chapter_number=$(sanitize_input "$REPLY")
dir_name="$manga_name.$chapter_number"
mkdir -p "$dir_name"

base_url=$(echo "$1" | sed 's/[0-9]\+\.png//')
# echo "$base_url"

echo "Downloading $manga_name chapter $chapter_number to $dir_name"
url="${base_url}001.png"
curl -sf "$url" --output "$dir_name/001.png"
if [ $? -ne 0 ]; then
    echo -e "\nFailed to download $url\nmake sure the base_url is correct"
    exit 1
fi
echo -ne "Progress: ["
# 30 should be enough for most weekly manga, zid ken ne9es
for i in $(seq -f "%03g" 2 30); do
    url="${base_url}${i}.png"
    curl -sf "$url" --output "$dir_name/$i.png"
    if [ $? -ne 0 ]; then
        echo -ne "] Done!\n"
        exit 1
    fi
    echo -n "#"
done
