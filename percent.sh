#!/bin/bash

# Calculate size of COBOL files, ignoring .swp files
cob_size=$(find src/ -type f \( -name "*.cob" -o -name "*.cpy" \) ! -name "*.swp" -exec stat -c%s {} + | awk '{s+=$1} END {print s}')

# Calculate size of all source files, ignoring .swp files
src_size=$(find src/ -type f ! -name "*.swp" -exec stat -c%s {} + | awk '{s+=$1} END {print s}')

# Size of index.html (unchanged)
html_size=$(stat -c%s index.html 2>/dev/null || echo 0)

# Total size
total_size=$(( src_size + html_size ))

# Percentage of COBOL size
percent=$(echo "scale=2; if ($total_size > 0) 100 * $cob_size / $total_size else 0" | bc)

# Output
echo "$percent" | tee res/percent.txt

