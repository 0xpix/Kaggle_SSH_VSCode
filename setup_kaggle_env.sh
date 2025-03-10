#!/bin/bash

echo "🚀 Updating system and installing dependencies..."
sudo apt update -y
sudo apt upgrade -y

echo "🔧 Installing dependencies..."
sudo apt install -y software-properties-common build-essential zlib1g-dev libffi-dev libssl-dev \
    libsqlite3-dev libbz2-dev liblzma-dev libreadline-dev libncursesw5-dev libgdbm-dev tk-dev \
    libgdbm-compat-dev libdb-dev gcc make wget curl

echo "🐍 Install Python"
sudo apt update
sudo apt install python3 python3-pip python3-venv

echo "🔗 Setting 'python' to point to 'python3'..."
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
python --version

echo "📦 Upgrading pip..."
pip install --upgrade pip

echo "🖥 Installing NVIDIA utilities..."
sudo apt install nvidia-utils-515 -y

echo "✅ Setup complete! 🎉"
