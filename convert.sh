#!/bin/bash

LISTDIR="$PWD/m3u8"
DESTDIR="$PWD/m3u8"
EXT="m3u8"
THREAD=3

find "$LISTDIR" -type f -name "*.$EXT" -print0 | while read -d '' file
do
    ((i=i%THREAD)); ((i++==0)) && wait
	echo -e "\e[34mProcessing: $file\e[0m"
	ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto \
		-i "file://$file" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 \
		"$DESTDIR"$(echo "${file//$LISTDIR/}" | sed -e 's/\.m3u8/\.mp4/g')  \
		> "$DESTDIR"$(echo "${file//$LISTDIR/}" | sed -e 's/.m3u8/.log/g' ) 2>&1 &
done