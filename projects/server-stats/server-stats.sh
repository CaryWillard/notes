#!/bin/bash

# cpu usage
cat /proc/stat | grep cpu | head -n 1 | awk '{print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}'| awk '{print "CPU Usage:\t" 100-$1 "%"}'

# memory usage
free | grep "Mem:" -w | awk '{printf "Total memory:\t%.1fGi\nUsed memory:\t%.1fGi\t(%.2f%%)\nFree memory:\t%.1fGi\t(%.2f%%)\n",$2/1024^2, $3/1024^2, $3/$2 * 100, $4/1024^2, $4/$2 * 100}'

# disk usage
df

# top 5 processes by cpu usage
# top 5 processes by memory usage

# uptime
echo "Uptime: $(uptime)"
