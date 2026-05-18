#!/bin/bash

echo "Service Status"
echo "=============="
echo ""

# Check Ollama
if pgrep -x "ollama" > /dev/null; then
    echo "✓ Ollama: Running"
else
    echo "✗ Ollama: Not running"
fi

# Check Open WebUI
if docker ps | grep -q "open-webui"; then
    echo "✓ Open WebUI: Running at http://localhost:3000"
else
    echo "✗ Open WebUI: Not running"
fi

# Check GPU
echo ""
echo "GPU Status:"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,memory.used,memory.total --format=csv,noheader 2>/dev/null || echo "GPU info unavailable"
else
    echo "NVIDIA drivers not found"
fi

# List pulled models
echo ""
echo "Pulled Models:"
ollama list 2>/dev/null || echo "No models pulled yet"
