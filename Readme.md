# CyberPanel Mod

## Quick Installation

Run this one-liner on your CyberPanel server as root:

```bash
sh <(curl -fsSL https://raw.githubusercontent.com/zpratikpathak/cyberpanel-true-repo/refs/heads/home/setup.sh || wget -qO- https://raw.githubusercontent.com/zpratikpathak/cyberpanel-true-repo/refs/heads/home/setup.sh)
```

## What It Does

1. Replaces the official license check URL across all CyberPanel files
2. Restarts the `lscpd` service to apply changes
