Run with: sudo bash desktop-install.sh

set -e

echo "Installing desktop mode scripts..."

CONFIG_DIR="/boot/firmware"
[ ! -d "$CONFIG_DIR" ] && CONFIG_DIR="/boot"
CONFIG="$CONFIG_DIR/config.txt"

# --- Create desktop.conf ---
cat > "$CONFIG_DIR/desktop.conf" << 'CONF_EOF'
# Desktop mode — overclocking profile
over_voltage=6
arm_freq=2000
gpu_freq=750
gpu_mem=256
CONF_EOF

# --- Create cli.conf ---
cat > "$CONFIG_DIR/cli.conf" << 'CONF_EOF'
# CLI mode — no overclocking
CONF_EOF

# --- Create default mode.conf (CLI) ---
cp "$CONFIG_DIR/cli.conf" "$CONFIG_DIR/mode.conf"

# --- Append include to config.txt if not already present ---
if ! grep -q 'include mode.conf' "$CONFIG"; then
    echo "" >> "$CONFIG"
    echo "# Dynamic profile (managed by desktop/cli scripts)" >> "$CONFIG"
    echo "include mode.conf" >> "$CONFIG"
    echo "[desktop-install] Added include directive to $CONFIG"
else
    echo "[desktop-install] include directive already present, skipping"
fi

# --- /usr/local/bin/desktop ---
cat > /usr/local/bin/desktop << DESKTOP_EOF
#!/bin/bash

if [ "\$EUID" -ne 0 ]; then
    exec sudo "\$0" "\$@"
fi

CONFIG_DIR="$CONFIG_DIR"

echo "[desktop] Switching to desktop profile..."
cp "\$CONFIG_DIR/desktop.conf" "\$CONFIG_DIR/mode.conf"

echo "[desktop] Setting GUI boot target..."
systemctl set-default graphical.target

touch /var/lib/desktop-boot-pending
echo "[desktop] Rebooting in 3 seconds..."
sleep 3
reboot
DESKTOP_EOF

# --- /usr/local/bin/desktop-cleanup ---
cat > /usr/local/bin/desktop-cleanup << CLEANUP_EOF
#!/bin/bash

CONFIG_DIR="$CONFIG_DIR"

if [ -f /var/lib/desktop-boot-pending ]; then
    rm -f /var/lib/desktop-boot-pending
    exit 0
fi

echo "[desktop-cleanup] Switching to CLI profile..."
cp "\$CONFIG_DIR/cli.conf" "\$CONFIG_DIR/mode.conf"

echo "[desktop-cleanup] Setting CLI boot target..."
systemctl set-default multi-user.target
CLEANUP_EOF

chmod +x /usr/local/bin/desktop /usr/local/bin/desktop-cleanup

# --- systemd shutdown service ---
cat > /etc/systemd/system/desktop-cleanup.service << 'SERVICE_EOF'
[Unit]
Description=Revert to CLI profile on shutdown
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target umount.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/desktop-cleanup
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target reboot.target halt.target
SERVICE_EOF

systemctl daemon-reload
systemctl enable desktop-cleanup.service

echo ""
echo "Done! Usage: type 'desktop' to switch to GUI mode."