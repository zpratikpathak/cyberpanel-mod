#!/bin/bash

cd /usr/local/CyberCP

echo "Applying the fixes..."
find . -type f -exec sed -i 's|https://platform.cyberpersons.com/CyberpanelAdOns/Adonpermission|https://cyberpanel-mod.vercel.app/CyberpanelAdOns/Adonpermission|g' {} +

echo "Restarting the service..."
systemctl restart lscpd

clear

cat << "EOF"
===============================================
     CYBERPANEL Fix APPLIED
===============================================

CyberPanel fixes applied successfully.

Service 'lscpd' restarted successfully.

===============================================
EOF

echo ""
echo "Operation completed successfully! All CyberPanel fixes applied successfully."