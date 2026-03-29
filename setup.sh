#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ORIG_URL="https://platform.cyberpersons.com/CyberpanelAdOns/Adonpermission"
NEW_URL="https://cyberpanel-mod.vercel.app/CyberpanelAdOns/Adonpermission"
CYBERCP_DIR="/usr/local/CyberCP"

progress_bar() {
    local current=$1 total=$2 width=40
    local pct=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    printf "\r  ${CYAN}[${GREEN}%s${NC}%s${CYAN}]${NC} ${BOLD}%3d%%${NC}" \
        "$(printf '#%.0s' $(seq 1 $filled 2>/dev/null))" \
        "$(printf '-%.0s' $(seq 1 $empty 2>/dev/null))" \
        "$pct"
}

echo ""
echo -e "${CYAN}${BOLD}=================================================${NC}"
echo -e "${CYAN}${BOLD}          CYBERPANEL MOD INSTALLER${NC}"
echo -e "${CYAN}${BOLD}=================================================${NC}"
echo ""

# --- Root check ---
if [ "$(id -u)" -ne 0 ]; then
    echo -e "  ${RED}${BOLD}ERROR:${NC} This script must be run as ${YELLOW}root${NC}."
    echo -e "  ${YELLOW}Try:${NC} sudo bash setup.sh"
    echo ""
    exit 1
fi
echo -e "  ${GREEN}✓${NC} Running as root"

# --- CyberPanel directory check ---
if [ ! -d "$CYBERCP_DIR" ]; then
    echo -e "  ${RED}${BOLD}ERROR:${NC} CyberPanel directory not found at ${YELLOW}${CYBERCP_DIR}${NC}"
    echo ""
    exit 1
fi
echo -e "  ${GREEN}✓${NC} CyberPanel directory found"
echo ""

# --- Scan files ---
echo -e "  ${YELLOW}→${NC} Scanning files..."
cd "$CYBERCP_DIR" || exit 1
mapfile -t files < <(find . -type f 2>/dev/null)
total=${#files[@]}
echo -e "  ${GREEN}✓${NC} Found ${BOLD}${total}${NC} files to process"
echo ""

# --- Apply patches ---
echo -e "  ${YELLOW}→${NC} Applying patches..."
patched=0
for i in "${!files[@]}"; do
    file="${files[$i]}"
    if grep -q "$ORIG_URL" "$file" 2>/dev/null; then
        sed -i "s|${ORIG_URL}|${NEW_URL}|g" "$file"
        ((patched++))
    fi
    progress_bar $((i + 1)) "$total"
done
echo ""
echo -e "  ${GREEN}✓${NC} Patched ${BOLD}${patched}${NC} files"
echo ""

# --- Restart service ---
echo -e "  ${YELLOW}→${NC} Restarting lscpd service..."
if systemctl restart lscpd 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} Service restarted successfully"
else
    echo -e "  ${RED}✗${NC} Failed to restart lscpd (may not be running)"
fi

# --- Done ---
echo ""
echo -e "${GREEN}${BOLD}=================================================${NC}"
echo -e "${GREEN}${BOLD}           INSTALLATION COMPLETE${NC}"
echo -e "${GREEN}${BOLD}=================================================${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} All premium features are now unlocked"
echo -e "  ${CYAN}ℹ${NC} Re-run this script after any CyberPanel update"
echo ""
