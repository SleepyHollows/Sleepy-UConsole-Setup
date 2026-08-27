# CLI + build toolchain
sudo apt install -y build-essential pkg-config git curl bc htop mc byobu \
    libxcb1-dev libasound2-dev libssl-dev golang

# Bluetui, for easy bluetooth management
cargo install bluetui

# Librawolf for a browser
sudo apt update && sudo apt install extrepo -y
sudo extrepo enable librewolf && sudo extrepo update librewolf
sudo apt update && sudo apt install librewolf -y

# yt-dlp separately, so it can self-update
#pipx install yt-dlp

#thefuck, for command fixes
sudo apt install the fuck
cat >>~/.bashrc << 'EOF'
eval $(thefuck --alias)
EOF

#Microsoft Word viewer
#https://github.com/bgreenwell/doxx
cargo install --git https://github.com/bgreenwell/doxx

#SSH Manager
#https://github.com/adembc/lazysshx
#cargo install --git https://github.com/adembc/lazysshx
git clone https://github.com/Adembc/lazyssh.git
cd lazyssh
cd cmd
go build -o ~/go/bin/lazyssh ./cmd

#Podcast
#https://github.com/xgi/castero
pip install --user castero

#System Utilization
#https://github.com/aristocratos/btop
sudo apt install btop

#Personal Information Dashboard
#https://github.com/wtfutil/wtf
go install github.com/wtfutil/wtf@latest

#Cyberspace
#https://github.com/ArmadilloBrillo/cyber-tui
git clone https://github.com/ArmadilloBrillo/cyber-tui.git
cd cyber-tui
go build -o ~/go/bin/cybertui ./cmd/cyber-tui

#Signal Messenger
#https://github.com/boxdot/gurk-rs
sudo apt install protobuf-compiler perl
cargo install --git [https://github.com/boxdot/gurk-rs](https://github.com/boxdot/gurk-rs) gurk

#Secure messaging network built on Reticulum
#https://github.com/markqvist/NomadNet
pip install nomadnet

#Music
#https://github.com/MattiaPun/SubTUI
sudo go install github.com/MattiaPun/SubTUI@latest
mv ~/go/bin/SubTUI ~/go/bin/subtui
mkdir ~/.config/subtui
cat >> ~/.config/subtui/credentials.toml << 'EOF'
url = 'http://:4533'
username = 'admin'
password = ''
EOF

#Note-taking app
#https://github.com/SourcewareLab/Toney

#Obsidian
#https://github.com/erikjuhani/basalt
git clone https://github.com/erikjuhani/basalt.git
cd basalt
cargo build --release
sudo install -m755 target/release/basalt /usr/local/bin/

#Anime watcher
#https://github.com/viu-media/viu
sudo apt install -y python3-dev pkg-config libdbus-1-dev libglib2.0-dev build-essential
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install "viu-media[standard]"

#Excel editor
git clone https://github.com/bgreenwell/xleak.git
cd xleak
cargo install --path .

#PDF viewer
cargo install --git https://github.com/itsjunetime/tdf.git

#Steam Gaming
#https://github.com/Drackrath/Aurelia
#sudo apt-get update
#sudo apt-get install build-essential pkg-config libssl-dev libx11-dev libxi-dev \
# libxrandr-dev libxinerama-dev libxcursor-dev libxkbcommon-dev libasound2-dev \
# libudev-dev libwayland-dev libgtk-3-dev libpulse-dev libdbus-1-dev \
# libegl1-mesa-dev libgles2-mesa-dev liblzma-dev
