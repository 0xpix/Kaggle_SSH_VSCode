#!/bin/bash

# Install Zrok
echo "Installing Zrok..."
curl -sSf https://get.openziti.io/install.bash | sudo bash -s zrok

echo "Zrok installation completed!"
