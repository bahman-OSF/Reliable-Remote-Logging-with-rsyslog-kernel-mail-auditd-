#!/bin/bash
set -e

echo "=============================="
echo " Source Machine Configuration "
echo "=============================="

# Ask for sudo password once (cached)
sudo -v

# Keep sudo alive
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Update & install packages
sudo apt update
sudo apt install -y rsyslog auditd audispd-plugins

# Copy rsyslog configs
sudo cp source-VM/10-imfile-load.conf /etc/rsyslog.d/
sudo cp source-VM/20* /etc/rsyslog.d/
sudo cp source-VM/30* /etc/rsyslog.d/

# Enable services
sudo systemctl enable --now rsyslog.service
sudo systemctl enable --now auditd.service

echo "✔ Source machine configured successfully"

echo "==================================="
echo " Destination Machine Configuration "
echo "==================================="

read -p "Enter DESTINATION IP: " DEST_IP
read -p "Enter DESTINATION USERNAME: " DEST_USER

echo
echo "→ Connecting to destination via SSH (key-based auth assumed)..."
echo "→ You may be prompted for the destination sudo password."

echo "→ Connecting to destination (installing packages)..."
ssh -tt "$DEST_USER@$DEST_IP" \
    "sudo -v && \
     while true; do sudo -n true; sleep 60; kill -0 \$\$ || exit; done 2>/dev/null & \
     sudo apt update && \
     sudo apt install -y rsyslog auditd audispd-plugins"

echo "→ Copying files..."
scp destination-VM/20-remote-input.conf "$DEST_USER@$DEST_IP:/tmp/"
scp destination-VM/30* "$DEST_USER@$DEST_IP:/tmp/"

echo "→ Moving and enabling services..."
ssh -tt "$DEST_USER@$DEST_IP" \
    "sudo mv /tmp/20-remote-input.conf /etc/rsyslog.d/ && \
     sudo mv /tmp/30* /etc/rsyslog.d/ && \
     sudo systemctl enable --now rsyslog.service && \
     sudo systemctl enable --now auditd.service"

echo "✔ Destination machine configured successfully"
