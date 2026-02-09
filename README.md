# Server Performance Stats Script

A Bash script that analyzes basic Linux server performance statistics.  
It provides a clean **table output for humans** and **JSON output for monitoring tools**.

This project helps build foundational knowledge for debugging and understanding Linux server performance.

---

## Features

- Total CPU usage
- Total memory usage (used vs free with percentage)
- Total disk usage (used vs free with percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- OS version
- System uptime
- Load average
- Logged-in users
- Failed login attempts
- Pretty table output
- JSON output for monitoring/automation tools

---

## Requirements

- Linux OS
- Bash shell
- Standard Linux utilities:
  - `top`
  - `free`
  - `df`
  - `ps`
  - `uptime`
  - `awk`

No additional packages required.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/zaryabzubair/server-performance.git
cd server-stats
```

---

## Make the script executable:

```bash
chmod +x server-stats.sh
```
---
## Commands
Run with pretty table output (default):
```bash
./server-stats.sh
```
Run with JSON output (for monitoring tools)
```bash
./server-stats.sh --json
```
Pretty-print JSON output (optional)
```bash
./server-stats.sh --json | jq .
```
Run as root (recommended for full stats)
```bash
sudo ./server-stats.sh
```

