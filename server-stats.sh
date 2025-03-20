#!/bin/bash
# Get system stats
TOP_OUTPUT=$(top -b -n 1 | grep -v "^top")

# CPU usage
CPU_IDLE=$(echo "$TOP_OUTPUT" | awk -F ',' '/Cpu/ {print $4}' | awk '{print $1}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

# Memory usage
read MEM_TOTAL MEM_FREE MEM_USED MEM_BUFF <<< $(echo "$TOP_OUTPUT" | awk -F '[,,:]' '/MiB Mem/ {print int($2), int($3), int($4), int($5)}')

# Disk usage
read DISK_TOTAL DISK_USED DISK_FREE <<< $(df -h / | awk 'NR==2 {print $2, $3, $4}')

# Get top 5 CPU processes
TOP_CPU_PROCS=$(echo "$TOP_OUTPUT" | awk 'NR>7' | sort -k9 -nr | head -5 | awk '{print $9, $12}')

# Get top 5 memory processes
TOP_MEM_PROCS=$(echo "$TOP_OUTPUT" | awk 'NR>7 {print $10, $12}' | sort -nr | head -5)

# Server uptime
UPTIME=$(uptime -p)

# Check argument
FORMAT="text"  # Default output format
if [[ "$1" == "--json" ]]; then
    FORMAT="json"
fi

# JSON format
if [[ "$FORMAT" == "json" ]]; then
    echo '{
      "cpu_usage": '"$CPU_USAGE"',
      "memory": {
        "total": '"$MEM_TOTAL"',
        "used": '"$MEM_USED"',
        "free": '"$MEM_FREE"',
        "buffers": '"$MEM_BUFF"'
      },
      "disk": {
        "total": "'"$DISK_TOTAL"'",
        "used": "'"$DISK_USED"'",
        "free": "'"$DISK_FREE"'"
      },
      "top_cpu_processes": [
        '"$(echo "$TOP_CPU_PROCS" | awk '{print "\"" $0 "\""}' | paste -sd, - )"'
      ],
      "top_mem_processes": [
        '"$(echo "$TOP_MEM_PROCS" | awk '{print "\"" $0 "\""}' | paste -sd, - )"'
      ],
      "uptime": "'"$UPTIME"'"
    }'
else
    # Regular text format
    echo "CPU Usage: $CPU_USAGE%"
    echo "Memory Usage: $MEM_USED MiB / $MEM_TOTAL MiB"
    echo "Disk Usage: Used $DISK_USED / Total $DISK_TOTAL"
    echo "Uptime: $UPTIME"
    echo "Top 5 CPU-Consuming Processes:"
    printf '%s\n' "$TOP_CPU_PROCS"
    echo "Top 5 Memory-Consuming Processes:"
    printf '%s\n' "$TOP_MEM_PROCS"
fi
