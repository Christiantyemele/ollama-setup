#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./pull-model.sh <model-name>"
    echo ""
    echo "Examples:"
    echo "  ./pull-model.sh qwen2.5-coder:7b"
    echo "  ./pull-model.sh codellama:7b"
    echo "  ./pull-model.sh mistral:7b"
    echo ""
    echo "Popular models for coding:"
    echo "  - qwen2.5-coder:7b    (Best for code, fits 16GB RAM)"
    echo "  - codellama:7b        (General coding)"
    echo "  - deepseek-coder:6.7b (Code completion)"
    echo "  - mistral:7b          (General purpose)"
    exit 1
fi

echo "Pulling model: $1"
ollama pull "$1"

echo "✓ Model pulled successfully"
echo "Refresh Open WebUI to see the model"
