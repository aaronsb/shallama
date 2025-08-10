#!/bin/bash

# Migration Script: Ollama to LlamaCP
# Helps migrate models and configuration from Ollama to LlamaCP

set -e

echo "🔄 Ollama to LlamaCP Migration Tool"
echo "=================================="

# Check if ollama directory exists
if [ ! -d "../ollama" ]; then
    echo "❌ Ollama directory not found at ../ollama"
    echo "   Please run this script from the llamacpp directory"
    exit 1
fi

# Function to check Ollama models
check_ollama_models() {
    echo "🔍 Checking for Ollama models..."
    
    if [ -d "../ollama/ollama_data/models/blobs" ]; then
        local blob_count=$(find ../ollama/ollama_data/models/blobs -name "sha256-*" | wc -l)
        echo "   Found $blob_count model blobs in Ollama storage"
        
        if [ -d "../ollama/ollama_data/models/manifests" ]; then
            echo "   Available models:"
            find ../ollama/ollama_data/models/manifests -type f | sed 's|.*/||' | sort
        fi
    else
        echo "   No Ollama model storage found"
    fi
}

# Function to export Ollama models to GGUF format
export_ollama_models() {
    echo ""
    echo "📦 Exporting Ollama models to GGUF format..."
    echo "   Note: This requires the Ollama container to be running"
    
    # Start Ollama if not running
    if ! docker ps -q -f name=ollama >/dev/null 2>&1; then
        echo "   Starting Ollama container for export..."
        cd ../ollama && ./start-ollama.sh && cd ../llamacpp
        sleep 10
    fi
    
    # Get list of models from Ollama
    echo "   Getting model list from Ollama..."
    local models=$(docker exec ollama ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    
    if [ -z "$models" ]; then
        echo "   No models found in Ollama"
        return
    fi
    
    echo "   Found models: $models"
    echo ""
    
    # Create models directory if it doesn't exist
    mkdir -p ./models
    
    # Export each model
    while IFS= read -r model; do
        if [ -n "$model" ]; then
            echo "   Exporting model: $model"
            local safe_name=$(echo "$model" | sed 's/[^a-zA-Z0-9._-]/_/g')
            local output_file="./models/${safe_name}.gguf"
            
            if [ ! -f "$output_file" ]; then
                echo "     -> $output_file"
                # Note: ollama export is not available in all versions
                # This is a placeholder for the export functionality
                docker exec ollama ollama show "$model" --modelfile > "./config/${safe_name}.modelfile" 2>/dev/null || true
                echo "     ⚠️  Direct GGUF export not available"
                echo "     💡 Manual download required from Hugging Face"
                echo "        Model: $model"
                echo "        Search: https://huggingface.co/models?search=$model"
            else
                echo "     ✅ Already exists"
            fi
        fi
    done <<< "$models"
    
    echo ""
    echo "📋 Export Summary:"
    echo "   - Model configs saved to ./config/"
    echo "   - Manual GGUF download required (Ollama doesn't support direct export)"
    echo "   - Check Hugging Face for GGUF versions of your models"
}

# Function to create model configuration
create_model_config() {
    echo "📝 Creating model configuration..."
    
    mkdir -p ./config
    
    # Get models from Ollama if available
    local ollama_models=""
    if docker ps -q -f name=ollama >/dev/null 2>&1; then
        ollama_models=$(docker exec ollama ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    fi
    
    # Create models.yaml with detected models
    cat > ./config/models.yaml << EOF
# LlamaCP Model Configuration
# Migrated from Ollama setup

models:
EOF
    
    if [ -n "$ollama_models" ]; then
        while IFS= read -r model; do
            if [ -n "$model" ]; then
                local safe_name=$(echo "$model" | sed 's/[^a-zA-Z0-9._-]/_/g')
                cat >> ./config/models.yaml << EOF
  $safe_name:
    path: "/models/${safe_name}.gguf"
    n_gpu_layers: 35  # Adjust based on your model size and GPU memory
    n_ctx: 8192       # Context length
    temperature: 0.7  # Adjust as needed
    
EOF
            fi
        done <<< "$ollama_models"
        
        # Set first model as default
        local first_model=$(echo "$ollama_models" | head -n 1 | sed 's/[^a-zA-Z0-9._-]/_/g')
        echo "default_model: \"$first_model\"" >> ./config/models.yaml
    else
        # Add example configuration
        cat >> ./config/models.yaml << EOF
  # Example configuration - add your models here
  # llama3-8b:
  #   path: "/models/llama-3-8b-instruct.Q4_K_M.gguf"
  #   n_gpu_layers: 35
  #   n_ctx: 8192
  #   temperature: 0.7

default_model: "llama3-8b"
EOF
    fi
    
    echo "   ✅ Configuration created: ./config/models.yaml"
}

# Function to copy Ollama environment settings
migrate_environment() {
    echo "🔧 Migrating environment settings..."
    
    # Check Ollama compose files for environment variables
    local ollama_env=""
    if [ -f "../ollama/docker-compose.yml" ]; then
        ollama_env=$(grep -E "OLLAMA_|environment:" ../ollama/docker-compose.yml || true)
    fi
    
    if [ -n "$ollama_env" ]; then
        echo "   Found Ollama environment variables:"
        echo "$ollama_env" | grep -v "environment:" | sed 's/^/     /'
        echo ""
        echo "   💡 These may need manual adaptation for LlamaCP"
        echo "      Check docker-compose.nvidia.yml to apply similar settings"
    fi
}

# Function to show migration completion steps
show_completion_steps() {
    echo ""
    echo "✅ Migration setup complete!"
    echo ""
    echo "🚀 Next Steps:"
    echo "1. Download GGUF models to ./models/ directory:"
    echo "   - Check Hugging Face for GGUF versions"
    echo "   - Use HuggingFace Hub: huggingface-hub download-model"
    echo "   - Or convert existing models with llama.cpp tools"
    echo ""
    echo "2. Edit ./config/models.yaml to configure your models"
    echo ""
    echo "3. Stop Ollama and start LlamaCP:"
    echo "   cd ../ollama && docker compose down"
    echo "   cd ../llamacpp && ./start-llamacpp.sh"
    echo ""
    echo "4. Test the migration:"
    echo "   ./llamacpp test"
    echo "   curl http://localhost:11434/api/tags"
    echo ""
    echo "📚 Useful Resources:"
    echo "   - GGUF models: https://huggingface.co/models?library=gguf"
    echo "   - Model conversion: https://github.com/ggerganov/llama.cpp#prepare-data--run"
}

# Main migration process
main() {
    check_ollama_models
    
    echo ""
    read -p "Continue with migration? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export_ollama_models
        create_model_config
        migrate_environment
        show_completion_steps
    else
        echo "Migration cancelled."
        exit 0
    fi
}

# Run main function
main "$@"