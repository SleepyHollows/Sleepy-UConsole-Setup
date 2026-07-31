curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

sudo apt install -y flatpak
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo apt install cargo

cho 'export PATH="$HOME/.go/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

cho 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc