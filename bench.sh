#!/bin/bash

if [ \"$NODE\" != \"UNDEFINED\" ]; then echo \"Launching nbench from $NODE\"; fi

lscpu | grep "Model name"

echo "Nbench single-theaded benchmark"
/opt/bin/nbench | awk '/INDEX/' | tail -3

echo "Single-threaded 7z benchmark"
7zr b -mmt=1 | awk '/Avr/ {print "Compression (Memory bound): " $4 " - Decompression (CPU bound):" $8}'

echo "Multi-threaded 7z benchmark"
7zr b | awk '/Avr/ {print "Compression (Memory bound): " $4 " - Decompression (CPU bound):" $8}'

echo "CPUbench1A benchmark"
/opt/bin/cpubench1a -run | awk '/THROUGHPUT/ {print "CPUBench1A: " $4}'
