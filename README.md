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


