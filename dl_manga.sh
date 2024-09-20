#!/bin/bash

if [ -z "$1" ]; then
    echo -e "Usage: $0 <base_url> (just before the number.png)\nExample: ./dl_manga.sh https://cdn.onepiecechapters.com/file/CDN-M-A-N/jjk_shin_"
    exit 1
fi

read -p "Enter manga name: "
manga_name="$REPLY"
read -p "Enter chapter number: "
chapter_number="$REPLY"
dir_name="$manga_name.$chapter_number"
mkdir -p "$dir_name"

base_url="$1"

echo "Downloading $manga_name chapter $chapter_number to $dir_name"
url="${base_url}001.png"
curl -sf "$url" --output "$dir_name/001.png"
if [ $? -ne 0 ]; then
    echo -e "\nFailed to download $url\nmake sure the base_url is correct"
    exit 1
fi
echo -ne "Progress: ["
for i in $(seq -f "%03g" 2 21); do
    url="${base_url}${i}.png"
    curl -sf "$url" --output "$dir_name/$i.png"
    if [ $? -ne 0 ]; then
        echo -ne "] Done!\n"
        exit 1
    fi
    echo -n "#"
done
