#!/bin/bash

set -a  # Automatically export all variables
source .env
set +a  # Disable auto export

# Thresholds (adjust as needed)
CPU_THRESHOLD=94
MEMORY_THRESHOLD=90
DISK_THRESHOLD=92

# Function to send message via Telegram bot
send_telegram_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?parse_mode=html" \
        -d "chat_id=$CHAT_ID" \
        -d "text=$message"
}

# Function to check CPU usage
check_cpu() {

    local cpu_usage=$(grep "%CPU(s):" | awk '{print 100 - $NF}')
    if (( $(echo "$cpu_usage >= $CPU_THRESHOLD" | bc -l) )); then
        send_detailed_report "⚠️ High CPU Usage: $cpu_usage%"
    fi
}

# Function to check Memory usage
check_memory() {

    local memory_usage=$(free | grep Mem | awk '{print ($3/$2)*100}')
    if (( $(echo "$memory_usage >= $MEMORY_THRESHOLD" | bc -l) )); then
        send_detailed_report "⚠️ High Memory Usage: $memory_usage%"
    fi
}

# Function to check Disk usage
check_disk() {
    local disk_usage=$(df -h | grep /dev/sda1 | awk '{print $5}' | cut -d'%' -f1)
    if (( $(echo "$disk_usage >= $DISK_THRESHOLD" | bc -l) )); then
        send_detailed_report "⚠️ High Disk Usage: $disk_usage%"
    fi
}

send_detailed_report() {

    local newMessage="$1"

    # Fetching system data
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_percentage=$(printf "%.1f%%" "$cpu_usage")
    ram_total=$(free -m | grep Mem | awk '{print $2}')
    ram_used=$(free -m | grep Mem | awk '{print $3}')
    ram_percentage=$(free | grep Mem | awk '{print ($3/$2)*100}')
    ram_percentage_formatted=$(printf "%.1f%%" "$ram_percentage")
    disk_total=$(df -h | grep /dev/vda1 | awk '{print $2}')
    disk_used=$(df -h | grep /dev/vda1 | awk '{print $3}')
    disk_percentage=$(df -h | grep /dev/vda1 | awk '{print $5}')

    # Prepare aligned table
    message="$newMessage
⚠️ Detailed System Usage:
<pre>
| Название | Объем      | Использовано           |
|----------|------------|------------------------|
| CPU      |            | $(printf "%-23s" "$cpu_percentage")|
| RAM      |$(printf "%-12s" "$ram_total MB")|$(printf "%-6s MB (%-12s)" "$ram_used" "$ram_percentage_formatted")|
| DISK     |$(printf "%-12s" "$disk_total")|$(printf "%-4s %-19s" "$disk_used"  "$disk_percentage")|
</pre>"

    # Send the message
    send_telegram_message "$message"
}

# Main function
main() {
    send_detailed_report "Мониторинг запущен"
    while true; do
        check_cpu
        check_memory
        check_disk
        sleep 300  # Check every 5 minutes (adjust as needed)
    done
}

# Run the monitoring script
main
