#Download dependencies
sudo apt install -y mpv libmpv-dev libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxcb1 libmpv-dev libsixel1 ffmpeg libssl3 build-essential pkg-config libssl-dev

#Download yt-dlp outside of apt because apt is terribly outdated
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

#install Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
sudo apt install -y flatpak
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#Allow Cargo to be called by system
echo 'export PATH="$HOME/.go/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#Install youtube-tui
cargo install --git https://github.com/siriusmart/youtube-tui

