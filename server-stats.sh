#!/bin/bash

MODE="table"
[ "$1" == "--json" ] && MODE="json"

HOSTNAME=$(hostname)
OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
UPTIME=$(uptime -p)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
USERS=$(who | wc -l)
TIMESTAMP=$(date -Is)

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if ($i ~ /id/) print 100-$(i-1)}')

read MEM_TOTAL MEM_USED MEM_FREE <<<$(free -m | awk 'NR==2{print $2, $3-$6-$7, $4}')
MEM_USED_PCT=$(awk "BEGIN {printf \"%.2f\", $MEM_USED/$MEM_TOTAL*100}")
MEM_FREE_PCT=$(awk "BEGIN {printf \"%.2f\", $MEM_FREE/$MEM_TOTAL*100}")

read DISK_TOTAL DISK_USED DISK_FREE DISK_PCT <<<$(df -h --total | awk '/total/ {print $2, $3, $4, $5}')

TOP_CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)
TOP_MEM=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 6)

FAILED_LOGINS=0
if [ -f /var/log/auth.log ]; then
    FAILED_LOGINS=$(grep -c "Failed password" /var/log/auth.log)
elif [ -f /var/log/secure ]; then
    FAILED_LOGINS=$(grep -c "Failed password" /var/log/secure)
fi

# ================= JSON OUTPUT =================
if [ "$MODE" == "json" ]; then
cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "hostname": "$HOSTNAME",
  "os": "$OS",
  "uptime": "$UPTIME",
  "load_average": "$LOAD_AVG",
  "logged_in_users": $USERS,
  "cpu_usage_percent": $CPU_USAGE,
  "memory": {
    "total_mb": $MEM_TOTAL,
    "used_mb": $MEM_USED,
    "free_mb": $MEM_FREE,
    "used_percent": $MEM_USED_PCT,
    "free_percent": $MEM_FREE_PCT
  },
  "disk": {
    "total": "$DISK_TOTAL",
    "used": "$DISK_USED",
    "free": "$DISK_FREE",
    "used_percent": "$DISK_PCT"
  },
  "failed_login_attempts": $FAILED_LOGINS
}
EOF
exit 0
fi

# ================= TABLE OUTPUT =================
printf "\n%-60s\n" "============================================================"
printf "%-25s | %-30s\n" "Metric" "Value"
printf "%-60s\n" "------------------------------------------------------------"
printf "%-25s | %-30s\n" "Hostname" "$HOSTNAME"
printf "%-25s | %-30s\n" "OS" "$OS"
printf "%-25s | %-30s\n" "Uptime" "$UPTIME"
printf "%-25s | %-30s\n" "Load Average" "$LOAD_AVG"
printf "%-25s | %-30s\n" "Logged-in Users" "$USERS"
printf "%-25s | %-30s\n" "CPU Usage" "$(printf "%.2f%%" "$CPU_USAGE")"
printf "%-25s | %-30s\n" "Memory Used" "$MEM_USED MB ($MEM_USED_PCT%)"
printf "%-25s | %-30s\n" "Memory Free" "$MEM_FREE MB ($MEM_FREE_PCT%)"
printf "%-25s | %-30s\n" "Disk Used" "$DISK_USED ($DISK_PCT)"
printf "%-25s | %-30s\n" "Disk Free" "$DISK_FREE"
printf "%-25s | %-30s\n" "Failed Logins" "$FAILED_LOGINS"
printf "%-60s\n" "============================================================"

echo
echo "Top 5 Processes by CPU"
echo "----------------------"
echo "$TOP_CPU"

echo
echo "Top 5 Processes by Memory"
echo "-------------------------"
echo "$TOP_MEM"
