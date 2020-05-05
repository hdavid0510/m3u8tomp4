#!/bin/bash

LISTDIR="$PWD/m3u8"
DESTDIR="$PWD"
EXT="m3u8"
MAX_THREAD=4

download(){
	# $1 = origin file
	# $2 = destination file
	echo -e "\e[93mBegin converting\e[0m\n\e[93m   Input file=\e[0m $1\n\e[93m  Output file=\e[0m $2\n\n"
	ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -nostdin\
		-i "file://$1" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 30 \
		"$2" > "$2".log 2>&1
}

find "$LISTDIR" -type f -name "*.$EXT" -print0 | while read -d '' file
do
    ((i=i%MAX_THREAD)); ((i++==0)) && wait
	download "$file" "$DESTDIR$(echo ${file//$LISTDIR/} | sed -E 's|(.*)\.'$EXT'|\1.mp4|')" &
done
