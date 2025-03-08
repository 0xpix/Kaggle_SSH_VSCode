#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./add_zrok_token.sh <your_zrok_token>"
    exit 1
fi

ZROK_TOKEN="$1"

# Enable Zrok with the provided token
zrok enable "$ZROK_TOKEN"

echo "Zrok enabled successfully!"
