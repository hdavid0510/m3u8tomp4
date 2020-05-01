#!/bin/bash

LISTDIR="/mnt/d/m3m8/input"
TARGDIR="/mnt/d/m3m8/output"
EXT="m3u8"
THREAD=3

for file in $(find $LISTDIR -type f -name "*.$EXT"); do
	((i=i%THREAD)); ((i++==0)) && wait
	echo "Processing: $file"
	ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -i file://$file -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 $TARGDIR/$(echo $file | sed -e 's/'$(echo $LISTDIR | sed -e 's/\//\\\//g')'//g' -e 's/m3u8/mp4/g') > $TARGDIR/$(echo $file | sed -e 's/'$(echo $LISTDIR | sed -e 's/\//\\\//g')'//g' -e 's/m3u8/log/g' ) 2>&1 &
done