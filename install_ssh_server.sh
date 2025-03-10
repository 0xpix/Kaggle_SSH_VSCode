#!/bin/bash

# Exit immediately if any command fails (except in apt update)
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

echo "Fixing APT repository issues..."

# Disable problematic repositories
sudo mv /etc/apt/sources.list.d/google-cloud.list /etc/apt/sources.list.d/google-cloud.list.disabled || true
sudo mv /etc/apt/sources.list.d/google-fast-socket.list /etc/apt/sources.list.d/google-fast-socket.list.disabled || true

# Retry apt update up to 3 times
for i in {1..3}; do
    sudo apt update --allow-releaseinfo-change -qq && break || sleep 5
done

echo "Installing OpenSSH Server..."
# Continue even if a package issue occurs
sudo apt install -y openssh-server || echo "Warning: Some packages failed to install, continuing..."

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
sudo service ssh restart || echo "Warning: SSH service restart failed, check logs."

echo "SSH server setup complete."
