#!/bin/bash

# Setup public - private key
mkdir -p /kaggle/working/.ssh
echo $1
FILE=/kaggle/working/.ssh/authorized_keys

# Download the public key
if test -f "$FILE"; then
    wget -O /kaggle/working/.ssh/temp "$1"
    cat /kaggle/working/.ssh/temp >> /kaggle/working/.ssh/authorized_keys
    rm /kaggle/working/.ssh/temp
else
    wget -O /kaggle/working/.ssh/authorized_keys "$1"
fi

# Set correct permissions
chmod 700 /kaggle/working/.ssh
chmod 600 /kaggle/working/.ssh/authorized_keys

# Install SSH-Server
sudo apt update -qq
sudo apt install -y openssh-server

# SSH Config
sudo tee -a /etc/ssh/sshd_config <<EOF
Port 22
PermitRootLogin yes
PasswordAuthentication no
AuthorizedKeysFile /kaggle/working/.ssh/authorized_keys
PubkeyAuthentication yes
EOF

# Restart SSH service
sudo service ssh restart
