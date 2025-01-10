#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

echo "Updating system..."
apt update && apt upgrade -y
apt remove gnome-terminal hexchat transmission-gtk celluloid libreoffice-* rhythmbox hypnotix webapp-manager pix drawing
echo "Installing basic dependencies..."
apt install -y wget curl git software-properties-common apt-transport-https

echo "Installing Kitty and Neovim..."
apt install -y kitty neovim fonts-jetbrains-mono

echo "Installing Discord with Vencord and Element..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb || apt --fix-broken install -y
rm -f discord.deb
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
wget -O /usr/share/keyrings/element-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/element-archive-keyring.gpg] https://packages.element.io/debian/ default main" | tee /etc/apt/sources.list.d/element.list
apt update && apt install -y element-desktop

echo "Installing Google Chrome and Brave..."
wget -q -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dpkg -i google-chrome.deb || apt --fix-broken install -y
rm -f google-chrome.deb
curl -fsS https://dl.brave.com/install.sh | sh

echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
rm microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code

echo "Installing Obsidian..."
wget -O obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.7.7/obsidian_1.7.7_amd64.deb"
dpkg -i obsidian.deb || apt --fix-broken install -y
rm -f obsidian.deb
apt install -y jstest-gtk
apt install -y mangohud
echo "Installing Free Download Manager..."
wget -O freedownloadmanager.deb "https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb"
dpkg -i freedownloadmanager.deb || apt --fix-broken install -y
rm -f freedownloadmanager.deb
flatpak install com.github.libresprite.LibreSprite
echo "Installing wget, curl, and git..."
apt install -y wget curl git

apt install -y python3 python3-pip
apt install -y build-essential
apt install -y dotnet-sdk-7.0
flatpak install com.getpostman.Postman
apt install -y sqlite3
apt install -y openjdk-17-jdk
apt install -y haruna
echo "Installing Audacity, OBS Studio, GIMP, Kdenlive..."
apt install -y audacity obs-studio gimp kdenlive lmms ardour 
apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing VirtualBox, qBittorrent, Audacious..."
apt install -y virtualbox qbittorrent audacious

echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "Installing PostgreSQL..."
apt install -y postgresql postgresql-contrib

echo "Replacing PulseAudio with PipeWire..."
apt install -y pipewire pipewire-audio-client-libraries pipewire-pulse pipewire-bin libspa-0.2-bluetooth wireplumber
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
apt remove -y pulseaudio
apt autoremove -y
if systemctl --user status pipewire | grep -q "active (running)"; then
    echo "PipeWire is active and running."
else
    echo "PipeWire setup encountered an issue. Please check manually."
fi

echo "Installing emulators..."
flatpak install org.godotengine.Godot
flatpak install io.github.simple64.simple64
flatpak install info.cemu.Cemu
flatpak install org.ryujinx.Ryujinx
flatpak install org.DolphinEmu.dolphin-emu
flatpak install org.ppsspp.PPSSPP
flatpak install net.pcsx2.PCSX2 -y
flatpak install flathub org.duckstation.DuckStation -y

echo "Setting up Linux for audio production..."
apt install -y ardour cadence carla lmms audacity

echo "Installing LV2 and VST plugin support..."
apt install -y calf-plugins lsp-plugins-lv2 zam-plugins

echo "Installing JACK utilities and enabling real-time privileges..."
apt install -y jackd2 qjackctl
usermod -a -G audio $(whoami)
echo "@audio   -  rtprio     95" >> /etc/security/limits.d/audio.conf
echo "@audio   -  memlock    unlimited" >> /etc/security/limits.d/audio.conf

echo "Installing HandBrake..."
apt install -y handbrake

echo "Final system cleanup..."
apt update && apt upgrade -y
apt autoremove -y && apt clean

echo "Finish :)"
