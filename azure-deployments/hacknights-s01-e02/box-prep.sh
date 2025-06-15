#!/bin/bash

set -euo pipefail
LOGFILE="/var/log/prep-box.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[*] Starting Kali box preparation..."

export DEBIAN_FRONTEND=noninteractive

echo "[*] Downloading and setting up Kali archive keyring..."

wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg

echo "[*] Updating and upgrading system..."

apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get autoclean -y

echo "[*] Installing XFCE desktop environment..."
echo "lightdm shared/default-x-display-manager select lightdm" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce
sudo DEBIAN_FRONTEND=noninteractive apt install -y lightdm

echo "[*] Enabling and starting XRDP service..."
sudo DEBIAN_FRONTEND=noninteractive apt install xrdp
systemctl enable xrdp
systemctl start xrdp

echo "[*] Installing kali tools..."
sudo apt install -y kali-linux-large

echo "[✔] Kali box is fully prepared, enjoy"