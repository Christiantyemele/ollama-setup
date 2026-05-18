#!/bin/bash

echo "Stopping Ollama + Open WebUI..."

# Stop Open WebUI
docker stop open-webui 2>/dev/null && echo "✓ Open WebUI stopped"

# Stop Ollama
pkill -x ollama 2>/dev/null && echo "✓ Ollama stopped"

echo "✓ All services stopped"
