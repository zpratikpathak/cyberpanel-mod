# CyberPanel Mod

Unlocks all CyberPanel premium addon features by redirecting license checks to a self-hosted endpoint that always returns `{"status": 1}`.

## Quick Installation

Run this one-liner on your CyberPanel server as root:

```bash
sh <(curl -fsSL https://raw.githubusercontent.com/zpratikpathak/cyberpanel-mod/refs/heads/home/setup.sh || wget -qO- https://raw.githubusercontent.com/zpratikpathak/cyberpanel-mod/refs/heads/home/setup.sh)
```

## What It Does

1. Replaces the official license check URL across all CyberPanel files
2. Restarts the `lscpd` service to apply changes

## Run Locally

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+)

### Steps

1. Clone the repo:

```bash
git clone https://github.com/zpratikpathak/cyberpanel-mod.git
cd cyberpanel-mod
```

2. Start the server:

```bash
node server.js
```

That's it. No dependencies needed. The server runs at `http://localhost:3000` and responds to any request with `{"status":1}`.

3. Test it:

```bash
curl -X POST http://localhost:3000/CyberpanelAdOns/Adonpermission
# Returns: {"status":1}
```

### Custom Port

```bash
PORT=8080 node server.js
```

### Run in Background (on your CyberPanel server)

```bash
nohup node server.js > /dev/null 2>&1 &
```

### Using With CyberPanel (self-hosted)

If running the server on the same machine as CyberPanel:

```bash
cd /usr/local/CyberCP
find . -type f -exec sed -i 's|https://platform.cyberpersons.com/CyberpanelAdOns/Adonpermission|http://localhost:3000/CyberpanelAdOns/Adonpermission|g' {} +
systemctl restart lscpd
```

### Deploy to Vercel (optional)

The `api/` folder contains a Vercel-compatible serverless function. To deploy:

```bash
npm i -g vercel
vercel
```

## Project Structure

```
cyberpanel-mod/
├── api/
│   └── CyberpanelAdOns/
│       └── Adonpermission.js   ← Vercel serverless function
├── server.js                   ← Standalone server (no dependencies)
├── setup.sh                    ← Installer script
├── package.json
├── vercel.json                 ← Vercel rewrites config
└── Readme.md
```
