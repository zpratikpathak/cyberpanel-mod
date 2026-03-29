#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ORIG_URL="https://platform.cyberpersons.com/CyberpanelAdOns/Adonpermission"
NEW_URL="https://cyberpanel-mod.vercel.app/CyberpanelAdOns/Adonpermission"
CYBERCP_DIR="/usr/local/CyberCP"

repeat_char() {
    char="$1"
    count="$2"
    str=""
    i=0
    while [ "$i" -lt "$count" ]; do
        str="${str}${char}"
        i=$((i + 1))
    done
    printf '%s' "$str"
}

progress_bar() {
    current=$1
    total=$2
    width=40
    pct=$((current * 100 / total))
    filled=$((current * width / total))
    empty=$((width - filled))
    printf "\r  ${CYAN}[${GREEN}%s${NC}%s${CYAN}]${NC} ${BOLD}%3d%%${NC}" \
        "$(repeat_char '#' "$filled")" \
        "$(repeat_char '-' "$empty")" \
        "$pct"
}

printf "\n"
printf "${CYAN}${BOLD}=================================================${NC}\n"
printf "${CYAN}${BOLD}          CYBERPANEL MOD INSTALLER${NC}\n"
printf "${CYAN}${BOLD}=================================================${NC}\n"
printf "\n"

# --- Root check ---
if [ "$(id -u)" -ne 0 ]; then
    printf "  ${RED}${BOLD}ERROR:${NC} This script must be run as ${YELLOW}root${NC}.\n"
    printf "  ${YELLOW}Try:${NC} sudo sh setup.sh\n"
    printf "\n"
    exit 1
fi
printf "  ${GREEN}✓${NC} Running as root\n"

# --- CyberPanel directory check ---
if [ ! -d "$CYBERCP_DIR" ]; then
    printf "  ${RED}${BOLD}ERROR:${NC} CyberPanel directory not found at ${YELLOW}%s${NC}\n" "$CYBERCP_DIR"
    printf "\n"
    exit 1
fi
printf "  ${GREEN}✓${NC} CyberPanel directory found\n"
printf "\n"

# --- Scan files ---
printf "  ${YELLOW}→${NC} Scanning files...\n"
cd "$CYBERCP_DIR" || exit 1
total=$(find . -type f 2>/dev/null | wc -l)
printf "  ${GREEN}✓${NC} Found ${BOLD}%d${NC} files to process\n" "$total"
printf "\n"

# --- Apply patches ---
printf "  ${YELLOW}→${NC} Applying patches...\n"
patched=0
current=0
find . -type f 2>/dev/null | while IFS= read -r file; do
    current=$((current + 1))
    if grep -q "$ORIG_URL" "$file" 2>/dev/null; then
        sed -i "s|${ORIG_URL}|${NEW_URL}|g" "$file"
        patched=$((patched + 1))
        printf '%d\n' 1
    fi
    progress_bar "$current" "$total"
done > /tmp/cyberpanel_mod_patched
printf "\n"
patched=$(wc -l < /tmp/cyberpanel_mod_patched)
rm -f /tmp/cyberpanel_mod_patched
printf "  ${GREEN}✓${NC} Patched ${BOLD}%d${NC} files\n" "$patched"
printf "\n"

# --- Restart service ---
printf "  ${YELLOW}→${NC} Restarting lscpd service...\n"
if systemctl restart lscpd 2>/dev/null; then
    printf "  ${GREEN}✓${NC} Service restarted successfully\n"
else
    printf "  ${RED}✗${NC} Failed to restart lscpd (may not be running)\n"
fi

# --- Done ---
printf "\n"
printf "${GREEN}${BOLD}=================================================${NC}\n"
printf "${GREEN}${BOLD}           INSTALLATION COMPLETE${NC}\n"
printf "${GREEN}${BOLD}=================================================${NC}\n"
printf "\n"
printf "  ${GREEN}✓${NC} All premium features are now unlocked\n"
printf "  ${CYAN}ℹ${NC}  Re-run this script after any CyberPanel update\n"
printf "\n"
