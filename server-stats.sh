#!/bin/bash

# ==========================================
# Server Stats
# A Bash script to analyze basic
# server performance statistics.
# ==========================================

# Exit if any command fails
set -o pipefail

# ------------------------------------------
# Check Operating System
# ------------------------------------------

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This script must be run on Linux."
    exit 1
fi

# ------------------------------------------
# Helper Functions
# ------------------------------------------

print_header() {
    echo
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

# ------------------------------------------
# System Information
# ------------------------------------------

echo "========================================"
echo "        SERVER PERFORMANCE STATS"
echo "========================================"

OS_NAME=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
UPTIME=$(uptime -p)
LOAD_AVERAGE=$(uptime | awk -F'load average:' '{print $2}' | xargs)
LOGGED_USERS=$(who | wc -l)

echo
echo "OS             : $OS_NAME"
echo "Uptime         : $UPTIME"
echo "Load Average   : $LOAD_AVERAGE"
echo "Logged In Users: $LOGGED_USERS"

# ------------------------------------------
# CPU Usage
# ------------------------------------------

print_header "CPU USAGE"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{
    for (i = 1; i <= NF; i++) {
        if ($i ~ /id,/) {
            idle = $(i-1)
            gsub(",", "", idle)
            print 100 - idle
            exit
        }
    }
}')

printf "Total CPU Usage: %.1f%%\n" "$CPU_USAGE"

# ------------------------------------------
# Memory Usage
# ------------------------------------------

print_header "MEMORY USAGE"

free -m | awk 'NR==2 {
    total = $2
    used = $3
    free = $4

    printf "Total: %.1f GB\n", total / 1024
    printf "Used : %.1f GB\n", used / 1024
    printf "Free : %.1f GB\n", free / 1024
    printf "Usage: %.1f%%\n", (used / total) * 100
}'

# ------------------------------------------
# Disk Usage
# ------------------------------------------

print_header "DISK USAGE"

df -h / | awk 'NR==2 {
    printf "Filesystem: %s\n", $1
    printf "Total     : %s\n", $2
    printf "Used      : %s\n", $3
    printf "Free      : %s\n", $4
    printf "Usage     : %s\n", $5
}'

# ------------------------------------------
# Top 5 Processes by CPU
# ------------------------------------------

print_header "TOP 5 PROCESSES BY CPU"

printf "%-8s %-12s %-8s %-8s %s\n" \
    "PID" "USER" "CPU%" "MEM%" "COMMAND"

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu |
    awk 'NR >= 2 && NR <= 6 {
        printf "%-8s %-12s %-8s %-8s %s\n", $1, $2, $3, $4, $5
    }'

# ------------------------------------------
# Top 5 Processes by Memory
# ------------------------------------------

print_header "TOP 5 PROCESSES BY MEMORY"

printf "%-8s %-12s %-8s %-8s %s\n" \
    "PID" "USER" "CPU%" "MEM%" "COMMAND"

ps -eo pid,user,%cpu,%mem,comm --sort=-%mem |
    awk 'NR >= 2 && NR <= 6 {
        printf "%-8s %-12s %-8s %-8s %s\n", $1, $2, $3, $4, $5
    }'

echo
echo "========================================"
echo "          END OF SERVER STATS"
echo "========================================"