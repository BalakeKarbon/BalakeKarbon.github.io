#!/bin/bash
cob_size=$(find src/ -type f \( -name "*.cob" -o -name "*.cpy" \) -exec stat -c%s {} + | awk '{s+=$1} END {print s}')
src_total_size=$(find src/ -type f -exec stat -c%s {} + | awk '{s+=$1} END {print s}')
html_size=$(stat -c%s index.html)
total_size=$((src_total_size + html_size))
percent=$(echo "scale=2; 100 * $cob_size / $total_size" | bc)
echo "$percent" | tee res/percent.txt
