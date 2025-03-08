#!/bin/bash

# Check if CUDA is already installed
if command -v nvcc &> /dev/null
then
    echo "CUDA is already installed, skipping installation."
    exit 0
fi

echo "Installing CUDA..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential dkms

# Download and install CUDA locally
mkdir -p /kaggle/working/cuda
cd /kaggle/working/cuda

wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb

# Update package lists
sudo apt-get update

# Install CUDA
sudo apt-get -y install cuda

# Set up environment variables for CUDA
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

echo "CUDA installation completed!"
