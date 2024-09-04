#!/bin/bash

if [ \"$NODE\" != \"UNDEFINED\" ]; then echo \"Launching nbench from $NODE\"; fi

lscpu | grep "Model name"

echo "Nbench single-theaded benchmark"
/opt/bin/nbench | awk '/INDEX/' | tail -3

echo "Single-threaded 7z benchmark"
7zr b -mmt=1 | awk '/Avr/ {print "Compression (Memory bound): " $4 " - Decompression (CPU bound):" $8}'

echo "Multi-threaded 7z benchmark"
7zr b | awk '/Avr/ {print "Compression (Memory bound): " $4 " - Decompression (CPU bound):" $8}'

echo "FFmpeg VP9 benchmark"
time (ffmpeg -i /opt/ffmpeg/video.MP4 -c:a libopus -b:a 96k -af 'aformat=channel_layouts='\''stereo'\''' -c:v libvpx-vp9 -g 200 -threads 8 -row-mt 1 -tile-columns 2 -quality good -speed 1 -b:v 0 -crf 31 -pass 1 -an -f null /dev/null 2>/dev/null && ffmpeg -y -i /opt/ffmpeg/video.MP4 -c:a libopus -b:a 96k -af 'aformat=channel_layouts='\''stereo'\''' -c:v libvpx-vp9 -g 200 -threads 8 -row-mt 1 -tile-columns 2 -quality good -speed 1 -b:v 0 -crf 31 -pass 2 -loglevel quiet -stats test.webm)

echo "CPUbench1A benchmark"
/opt/bin/cpubench1a -run 2>&1 | awk '/THROUGHPUT/ {print "CPUBench1A: " $4}'
