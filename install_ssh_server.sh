#!/bin/bash

# Exit immediately if any command fails
set -e

# Validate input
if [ -z "$1" ]; then
    echo "Error: No public key URL provided."
    exit 1
fi

SSH_DIR="/kaggle/working/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

echo "Setting up SSH keys..."

# Create SSH directory if not exists
mkdir -p "$SSH_DIR"

# Download and update public key
if [ -f "$AUTHORIZED_KEYS" ]; then
    wget -q -O - "$1" >> "$AUTHORIZED_KEYS" || { echo "Failed to download public key."; exit 1; }
else
    wget -q -O "$AUTHORIZED_KEYS" "$1" || { echo "Failed to download public key."; exit 1; }
fi

# Set correct permissions
chmod 700 "$SSH_DIR"
chmod 600 "$AUTHORIZED_KEYS"

echo "Installing OpenSSH Server..."
sudo apt update -qq
sudo apt install -y openssh-server

echo "Configuring SSH Server..."

# Ensure sshd_config contains required settings (without duplicates)
sudo sed -i '/^Port/d' /etc/ssh/sshd_config
sudo sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config
sudo sed -i '/^PasswordAuthentication/d' /etc/ssh/sshd_config
sudo sed -i '/^AuthorizedKeysFile/d' /etc/ssh/sshd_config
sudo sed -i '/^PubkeyAuthentication/d' /etc/ssh/sshd_config

# Append necessary configurations
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOF
Port 22
PermitRootLogin prohibit-password
PasswordAuthentication no
AuthorizedKeysFile $AUTHORIZED_KEYS
PubkeyAuthentication yes
EOF

# Restart SSH service
echo "Restarting SSH service..."
sudo service ssh restart

echo "SSH server setup complete."
