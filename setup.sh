#!/bin/bash
set -e

echo "🚀 Ollama + Open WebUI Setup Script"
echo "===================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "❌ Please do not run as root"
   exit 1
fi

echo -e "${YELLOW}Step 1: Installing Ollama...${NC}"
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
    echo -e "${GREEN}✓ Ollama installed${NC}"
else
    echo -e "${GREEN}✓ Ollama already installed${NC}"
fi

echo -e "${YELLOW}Step 2: Checking NVIDIA GPU...${NC}"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
    echo -e "${GREEN}✓ NVIDIA GPU detected${NC}"
else
    echo "⚠️  NVIDIA drivers not found. GPU acceleration may not work."
fi

echo -e "${YELLOW}Step 3: Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker first:"
    echo "   https://docs.docker.com/engine/install/"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}"

echo -e "${YELLOW}Step 4: Installing NVIDIA Container Toolkit...${NC}"
if ! docker info | grep -q "nvidia"; then
    echo "Installing NVIDIA Container Toolkit..."
    # Add the package repositories
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    
    sudo apt-get update
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker
    echo -e "${GREEN}✓ NVIDIA Container Toolkit installed${NC}"
else
    echo -e "${GREEN}✓ NVIDIA Container Toolkit already configured${NC}"
fi

echo -e "${YELLOW}Step 5: Setting up Open WebUI...${NC}"

# Stop existing container if running
if docker ps -a | grep -q "open-webui"; then
    echo "Stopping existing Open WebUI container..."
    docker stop open-webui 2>/dev/null || true
    docker rm open-webui 2>/dev/null || true
fi

# Pull and run Open WebUI with GPU support
docker pull ghcr.io/open-webui/open-webui:main

docker run -d \
  -p 3000:8080 \
  --gpus all \
  -v ollama:/root/.ollama \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

echo -e "${GREEN}✓ Open WebUI started${NC}"

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Open WebUI is running at: http://localhost:3000"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Pull a model: ollama pull qwen2.5-coder:7b"
echo "3. Start chatting!"
echo ""
echo "Useful commands:"
echo "  ./start.sh    - Start services"
echo "  ./stop.sh     - Stop services"
echo "  ./status.sh   - Check status"
