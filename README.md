# Ollama + Open WebUI Setup

Automated setup scripts for deploying Ollama with Open WebUI dashboard on Linux machines with NVIDIA GPUs.

## Quick Start

```bash
# Clone this repository
git clone https://github.com/Christiantyemele/ollama-setup.git
cd ollama-setup

# Run the setup
chmod +x setup.sh
./setup.sh
```

## What It Installs

- **Ollama** - Local LLM runner (https://ollama.com)
- **Open WebUI** - ChatGPT-like web interface for Ollama
- **NVIDIA Container Toolkit** - GPU support for Docker

## Requirements

- Linux (Ubuntu/Debian recommended)
- NVIDIA GPU(s)
- Docker installed
- 16GB+ RAM recommended
- 10GB+ free disk space

## After Setup

1. **Access Open WebUI**: http://localhost:3000
2. **Pull a model**: `ollama pull qwen2.5-coder:7b`
3. **Start chatting** through the web interface

## Available Models

Recommended for coding with your specs (16GB RAM, 2x GPU):

| Model | Size | Best For |
|-------|------|----------|
| `qwen2.5-coder:7b` | 7B | Code generation, debugging |
| `codellama:7b` | 7B | General coding tasks |
| `deepseek-coder:6.7b` | 6.7B | Code completion |
| `mistral:7b` | 7B | General purpose |

## Scripts

- `setup.sh` - Full installation
- `start.sh` - Start services
- `stop.sh` - Stop services
- `pull-model.sh` - Pull a specific model

## Troubleshooting

### GPU not detected
```bash
nvidia-smi  # Check GPU is visible
```

### Reset everything
```bash
./stop.sh
docker rm -f open-webui
ollama stop
```

## License

MIT - Use freely, modify as needed.
