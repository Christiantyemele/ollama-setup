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

# Wait for Open WebUI to actually start serving before reporting success
wait_for_webui() {
    local url="http://localhost:3000"
    local attempts=30
    local count=0
    echo "Waiting for Open WebUI to become ready..."
    until curl -fsS -o /dev/null "$url"; do
        count=$((count + 1))
        if [ "$count" -ge "$attempts" ]; then
            return 1
        fi
        sleep 2
    done
    echo "✓ Open WebUI is ready"
    return 0
}

if wait_for_webui; then
    echo "✓ Services started"
    echo "Open WebUI: http://localhost:3000"
    echo ""
    echo "Run ./status.sh to check status"
else
    echo "⚠️  Open WebUI did not become ready within 30 attempts (~60s)."
    echo "   The container is running but not yet responding; check http://localhost:3000 or run ./status.sh."
    exit 1
fi
