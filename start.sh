#!/bin/bash

echo "Starting Ollama + Open WebUI..."

# Start Ollama service
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama..."
    ollama serve &
    sleep 2
fi

# Start Open WebUI container
if ! docker ps | grep -q "open-webui"; then
    echo "Starting Open WebUI..."
    docker start open-webui 2>/dev/null || {
        echo "Open WebUI container not found. Run ./setup.sh first."
        exit 1
    }
fi

echo "✓ Services started"
echo "Open WebUI: http://localhost:3000"
echo ""
echo "Run ./status.sh to check status"
