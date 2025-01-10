#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

# Updating system
echo "Updating system..."
apt update && apt upgrade -y
apt remove -y gnome-terminal hexchat transmission-gtk celluloid libreoffice-* rhythmbox hypnotix webapp-manager pix drawing

# Installing essential utilities
echo "Installing basic dependencies..."
apt install -y wget curl git software-properties-common apt-transport-https python3 python3-pip build-essential sqlite3 openjdk-17-jdk

# Installing terminal & text editor
echo "Installing Kitty and Neovim..."
apt install -y kitty neovim fonts-jetbrains-mono

# Installing communication apps (Discord, Vencord, Element)
echo "Installing Discord with Vencord and Element..."
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg -i discord.deb || apt --fix-broken install -y
rm -f discord.deb
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

# Onlyoffice installation
flatpak install org.onlyoffice.desktopeditors  -y

# Element installation
wget -O /usr/share/keyrings/element-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/element-archive-keyring.gpg] https://packages.element.io/debian/ default main" | tee /etc/apt/sources.list.d/element.list
apt update && apt install -y element-desktop

# Installing browsers
echo "Installing Google Chrome and Brave..."
wget -q -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dpkg -i google-chrome.deb || apt --fix-broken install -y
rm -f google-chrome.deb
curl -fsS https://dl.brave.com/install.sh | sh

# Installing Visual Studio Code
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
rm microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code

# Installing Obsidian & other tools
echo "Installing Obsidian, Free Download Manager..."
wget -O obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.7.7/obsidian_1.7.7_amd64.deb"
dpkg -i obsidian.deb || apt --fix-broken install -y
rm -f obsidian.deb

# Installing Free Download Manager
wget -O freedownloadmanager.deb "https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb"
dpkg -i freedownloadmanager.deb || apt --fix-broken install -y
rm -f freedownloadmanager.deb

# Installing gaming and entertainment (Steam, Heroic, emulators)
echo "Installing Steam and Heroic Games Launcher..."
sudo add-apt-repository multiverse
sudo apt update
sudo apt install -y steam lutris wine64 gamemode
flatpak install com.heroicgameslauncher.hgl -y

echo "Installing emulators..."
flatpak install org.godotengine.Godot -y
flatpak install io.github.simple64.simple64 -y
flatpak install info.cemu.Cemu -y
flatpak install org.ryujinx.Ryujinx -y
flatpak install org.DolphinEmu.dolphin-emu -y
flatpak install org.ppsspp.PPSSPP -y
flatpak install net.pcsx2.PCSX2 -y
flatpak install flathub org.duckstation.DuckStation -y
flatpak install io.github.lime3ds.Lime3DS -y
flatpak install org.libretro.RetroArch -y
flatpak install com.github.tchx84.Flatseal -y
flatpak install net.davidotek.pupgui2 -y
flatpak install app.xemu.xemu -y

# Installing development tools (Node.js, PostgreSQL, etc.)
echo "Installing development tools..."
apt install -y nodejs dotnet-sdk-7.0 cmake 
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y postgresql postgresql-contrib
flatpak install com.getpostman.Postman -y

# Installing audio production tools
echo "Installing software for audio production..."
apt install -y ardour cadence carla lmms audacity
apt install -y calf-plugins lsp-plugins-lv2 zam-plugins
apt install -y jackd2 qjackctl

# Installing PipeWire and configuring
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

# Installing system utilities
echo "Installing HandBrake, zsh, LV2 plugins, and fonts..."
apt install -y handbrake zsh ttf-mscorefonts-installer
sudo apt install -y virtualbox qbittorrent audacious

# Installing Timeshift, GIMP, and Inkscape
echo "Installing Timeshift, GIMP, and Inkscape..."
apt install -y timeshift gimp inkscape

# Final cleanup
echo "Final system cleanup..."
apt update && apt upgrade -y
apt autoremove -y && apt clean

# Installing Oh My Zsh
echo "Setting up Zsh with Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Finish :)"
