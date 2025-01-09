#!/bin/bash

echo "Updating system..."
apt update && apt upgrade -y

echo "Installing basic dependencies..."
apt install -y wget curl git software-properties-common apt-transport-https

echo "Installing Neovim..."
apt install -y neovim
echo "Installing Discord..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb || apt --fix-broken install -y
rm -f discord.deb
echo "Installing Google Chrome..."
wget -q -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dpkg -i google-chrome.deb || apt --fix-broken install -y
rm -f google-chrome.deb
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
rm microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code
echo "Installing Obsidian..."
wget -O obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.13/Obsidian-1.4.13.deb"
dpkg -i obsidian.deb || apt --fix-broken install -y
rm -f obsidian.deb
echo "Installing Free Download Manager..."
wget -O freedownloadmanager.deb "https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb"
dpkg -i freedownloadmanager.deb || apt --fix-broken install -y
rm -f freedownloadmanager.deb
echo "Installing wget and curl..."
apt install -y wget curl
echo "Installing Git..."
apt install -y git
echo "Installing Audacity..."
apt install -y audacity
echo "Installing OBS Studio..."
apt install -y obs-studio
echo "Installing GIMP..."
apt install -y gimp
echo "Installing Kdenlive..."
apt install -y kdenlive
echo "Installing VirtualBox..."
apt install -y virtualbox
echo "Installing qBittorrent..."
apt install -y qbittorrent
echo "Installing Audacious..."
apt install -y audacious
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs
echo "Installing PostgreSQL..."
apt install -y postgresql postgresql-contrib

# Replace PulseAudio with PipeWire
echo "Replacing PulseAudio with PipeWire..."
apt install -y pipewire pipewire-audio-client-libraries pipewire-pulse pipewire-bin libspa-0.2-bluetooth wireplumber
echo "Configuring PipeWire..."
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
echo "Removing PulseAudio..."
apt remove -y pulseaudio
apt autoremove -y
if systemctl --user status pipewire | grep -q "active (running)"; then
    echo "PipeWire is active and running."
else
    echo "PipeWire setup encountered an issue. Please check manually."
fi
echo "Final system cleanup..."
apt update && apt upgrade -y
apt autoremove -y && apt clean
echo "script finish :)"
