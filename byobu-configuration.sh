#!/bin/bash
# Add tailscale IP address to status bar
mkdir -p ~/.byobu/bin
cat > ~/.byobu/bin/10_tailscale << 'EOF'
#!/bin/bash
# Current WiFi SSID
SSID=$(iwgetid -r 2>/dev/null)
# Local IP used for Internet routing
LAN_IP=$(ip -4 route get 1.1.1.1 2>/dev/null \
    | awk '/src/ {for(i=1;i<=NF;i++) if($i=="src"){print $(i+1); exit}}')
# Tailscale IP
TS_IP=$(tailscale ip -4 2>/dev/null | head -n1)
printf "%s %s %s\n" \
    "${SSID:-NoWiFi}" \
    "${TS_IP:-NoTS}"
EOF
chmod +x ~/.byobu/bin/10_tailscale

# Organize the status bar
sed -i 's|^tmux_right=.*|tmux_right="reboot_required updates_available custom ip_address wifi_quality cpu_freq memory disk battery date time"|' ~/.byobu/status
sed -i 's/#custom/custom/' ~/.byobu/status
rm -rf /run/user/$(id -u)/byobu/cache.tmux/custom* 2>/dev/null

# Create the filepath to modify byobu keybindings if it doesn't already exist
mkdir -p ~/.byobu

# Write keybindings to byobu so you can use them
cat > ~/.byobu/keybindings.tmux << 'EOF'
# Pane select left = Alt + Left
bind-key -n M-Left select-pane -L
# Window rename = Ctrl + r
bind-key -n C-r command-prompt -I "#W" "rename-window '%%'"
# Split window = Ctrl + s
bind-key -n C-s split-window
# Next window = Shift + Right
bind-key -n S-Right select-window -t :+
# Previous window = Shift + Left
bind-key -n S-Left select-window -t :-
# New window = Ctrl + n
bind-key -n C-n new-window
# Close window = Ctrl + q
bind-key -n C-q kill-window
# Window overview = Alt + Tab
bind-key -n M-Tab choose-window
# Paste = Ctrl + v
bind-key -n C-v paste-buffer
EOF

# Reload byobu config (status bar) if inside a session
byobu-config reload 2>/dev/null || true

# Reload keybindings now if we're inside a tmux/byobu session
if [ -n "$TMUX" ]; then
    tmux source-file ~/.byobu/keybindings.tmux
else
    echo "Not inside a tmux/byobu session — keybindings will apply next time byobu starts."
fi
