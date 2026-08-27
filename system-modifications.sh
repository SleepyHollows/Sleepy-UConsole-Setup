#Write keyboard Bindings to allow Ctrl/Shift + Arrow Keys
cat << 'EOF' | sudo tee /etc/console-setup/remap.inc
# ===== Ctrl + Arrow keys (modifier code 5) =====

# Ctrl + Left  -> ^[[1;5D
control keycode 105 = F100
string F100 = "\033[1;5D"

# Ctrl + Right -> ^[[1;5C
control keycode 106 = F101
string F101 = "\033[1;5C"

# Ctrl + Up    -> ^[[1;5A
control keycode 103 = F102
string F102 = "\033[1;5A"

# Ctrl + Down  -> ^[[1;5B
control keycode 108 = F103
string F103 = "\033[1;5B"


# ===== Shift + Arrow keys (modifier code 2) =====

# Shift + Left  -> ^[[1;2D
shift keycode 105 = F104
string F104 = "\033[1;2D"

# Shift + Right -> ^[[1;2C
shift keycode 106 = F105
string F105 = "\033[1;2C"

# Shift + Up    -> ^[[1;2A
shift keycode 103 = F106
string F106 = "\033[1;2A"

# Shift + Down  -> ^[[1;2B
shift keycode 108 = F107
string F107 = "\033[1;2B"
EOF

#Set keyboard Binding changes to load on every system bootup
sudo tee /etc/systemd/system/console-remap.service << 'EOF'
[Unit]
Description=Load custom console key remap
After=systemd-user-sessions.service

[Service]
Type=oneshot
ExecStart=/usr/bin/loadkeys /etc/console-setup/remap.inc
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable console-remap.service

#Force load the console keybindings so you can use them now
sudo loadkeys /etc/console-setup/remap.inc
#
#
#
#Increase charging speed of UConsole
echo 'KERNEL=="axp20x-battery", ATTR{constant_charge_current_max}="2200000", ATTR{constant_charge_current}="2000000"' | sudo tee /etc/udev/rules.d/99-uconsole-charging.rules
#
#
#
# Apply the workaround mkinitramfs itself suggests
echo "MODULES=most" | sudo tee -a /etc/initramfs-tools/initramfs.conf

# Now finish configuring the stuck packages
sudo dpkg --configure -a

sudo apt-get update
