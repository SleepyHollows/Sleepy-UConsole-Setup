# Apply the workaround mkinitramfs itself suggests
echo "MODULES=most" | sudo tee -a /etc/initramfs-tools/initramfs.conf

# Now finish configuring the stuck packages
sudo dpkg --configure -a

sudo apt-get update

#Get Sway installed and setup so that keybindings and everything works and looks clean
sudo apt install sway alacritty foot
mkdir -p ~/.config/sway
cat > ~/.config/sway/config << 'EOF'
set $mod Mod1
set $term alacritty
exec alacritty

#core
bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec swaymsg exit
bindsym $mod+b exec chromium
bindsym $mod+q kill
bindsym $mod+t exec $term

#focus movement
bindsym $mod+h focus left
bindsym $mod+l focus right
bindsym $mod+j focus down
bindsym $mod+k focus up

#workspaces
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5

#move window to workspace
bindsym Ctrl+1 move container to workspace 1
bindsym Ctrl+2 move container to workspace 2
bindsym Ctrl+3 move container to workspace 3
bindsym Ctrl+4 move container to workspace 4
bindsym Ctrl+5 move container to workspace 5

#no bar — you're handling status via tmux
bar {
   position top
   status_command ~/.tmux/status.sh
   font pango:monospace 12
   height 12
   mode dock
}

#borders - no title bars, thin pixel border instead
default_border pixel 2
default_floating_border pixel 2
EOF


#Make the status bar for system Info
mkdir -p ~/.tmux
cat > ~/.tmux/status.sh << 'EOF'
#!/usr/bin/env bash

while true; do

IP=$(hostname -I | awk '{print $1}')

SSID=$(iwgetid -r 2&gt;/dev/null)

[ -z "$SSID" ] &amp;&amp; SSID="no-wifi"

BATT=$(cat /sys/class/power_supply/*/capacity 2&gt;/dev/null | head -n1)

[ -z "$BATT" ] &amp;&amp; BATT="?"

DISK=$(df -h / | awk 'NR==2{print $5}')

RAM=$(free | awk '/Mem/{printf "%.0f%%", $3/$2*100}')

echo "  ${SSID} | ${IP} | RAM ${RAM} | DISK ${DISK} | BATT ${BATT}%"

sleep 5
done
EOF


#Get rid of annoying terminal top bar
mkdir -p ~/.config/alacritty
cat > ~/.config/alacritty/alacritty.toml << 'EOF'
[window]

decorations = "none"
EOF

#Set Sway for bootup
cat > ~/.bash_profile << 'EOF'
if [ -z "DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
   exec sway
fi
