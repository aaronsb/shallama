#!/bin/bash

# LlamaCP GPU Detection and Startup Script
# Based on the ollama setup but optimized for llama.cpp

set -e

echo "🦙 Starting LlamaCP (llama.cpp) with auto-GPU detection..."

# Function to check if Ollama is running and stop it
check_and_stop_ollama() {
    if docker ps -q -f name=ollama >/dev/null 2>&1; then
        echo "⚠️  Ollama container is running. Stopping to avoid resource conflicts..."
        cd ../ollama && docker compose down
        echo "✅ Ollama stopped successfully"
        cd ../llamacpp
    fi
}

# Function to detect NVIDIA GPU
detect_nvidia_gpu() {
    if command -v nvidia-smi >/dev/null 2>&1; then
        if nvidia-smi >/dev/null 2>&1; then
            echo "✅ NVIDIA GPU detected: $(nvidia-smi --query-gpu=name --format=csv,noheader)"
            echo "   VRAM: $(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits) MB"
            return 0
        fi
    fi
    return 1
}

# Function to detect Intel GPU
detect_intel_gpu() {
    if [ -d "/dev/dri" ] && [ "$(ls -A /dev/dri 2>/dev/null)" ]; then
        if lspci | grep -i "vga.*intel" >/dev/null 2>&1; then
            echo "✅ Intel GPU detected"
            return 0
        fi
    fi
    return 1
}

# Function to start with NVIDIA configuration
start_nvidia() {
    echo "🚀 Starting with NVIDIA GPU acceleration..."
    
    # Check for NVIDIA Container Toolkit
    if ! docker run --rm --gpus all ubuntu:20.04 sh -c "ls /dev/nvi* >/dev/null 2>&1" >/dev/null 2>&1; then
        echo "❌ NVIDIA Container Toolkit not properly configured"
        echo "   Please install nvidia-container-toolkit and restart Docker"
        exit 1
    fi
    
    ln -sf docker-compose.nvidia.yml docker-compose.yml
    echo "   Configuration: docker-compose.nvidia.yml"
}

# Function to start with CPU-only configuration
start_cpu() {
    echo "🔄 Starting with CPU-only configuration..."
    ln -sf docker-compose.cpu.yml docker-compose.yml
    echo "   Configuration: docker-compose.cpu.yml"
    echo "   Using $(nproc) CPU cores"
}

# Function to create default model configuration
create_default_config() {
    if [ ! -f "./config/models.yaml" ]; then
        mkdir -p ./config
        cat > ./config/models.yaml << EOF
# LlamaCP Model Configuration
# Add your models here for automatic loading

models:
  # Example configuration - uncomment and modify as needed
  # llama3-8b:
  #   path: "/models/llama-3-8b-instruct.Q4_K_M.gguf"
  #   n_gpu_layers: 35
  #   n_ctx: 8192
  #   temperature: 0.7
  
  # phi4-14b:
  #   path: "/models/phi-4.Q4_K_M.gguf"
  #   n_gpu_layers: 40
  #   n_ctx: 16384
  #   temperature: 0.8

# Default model to load on startup
default_model: "llama3-8b"
EOF
        echo "📄 Created default model configuration: ./config/models.yaml"
        echo "   Edit this file to configure your models"
    fi
}

# Main execution
main() {
    # Check and stop Ollama if running
    check_and_stop_ollama
    
    # Create default configuration
    create_default_config
    
    # Detect and configure GPU
    if detect_nvidia_gpu; then
        start_nvidia
    elif detect_intel_gpu; then
        echo "⚠️  Intel GPU detected but not yet supported in this configuration"
        echo "   Falling back to CPU mode"
        start_cpu
    else
        echo "ℹ️  No compatible GPU detected"
        start_cpu
    fi
    
    # Start the container
    echo "🔄 Starting LlamaCP container..."
    docker compose up -d
    
    # Wait for health check
    echo "⏳ Waiting for LlamaCP to be ready..."
    sleep 5
    
    # Check if container is healthy
    for i in {1..12}; do
        if docker compose ps | grep -q "healthy"; then
            echo "✅ LlamaCP is ready!"
            echo "   API endpoint: http://localhost:11434"
            echo "   Compatible with Ollama API clients"
            echo ""
            echo "📋 Next steps:"
            echo "   1. Add models to ./models/ directory"
            echo "   2. Configure models in ./config/models.yaml"
            echo "   3. Use ./llamacpp script for model management"
            echo ""
            echo "🔍 Test with: curl http://localhost:11434/api/tags"
            exit 0
        fi
        echo "   Waiting... ($i/12)"
        sleep 5
    done
    
    echo "⚠️  LlamaCP may still be starting. Check with: docker compose logs"
}

# Run main function
main "$@"