# ✨ Shallama 🦙 ✨

<div align="center">
  <img src="magical-llama-genie.png" alt="Magical Llama emerging from a genie lamp" width="400"/>
  <br>
  <em>✨ Where llama.cpp meets magical wishes! ✨</em>
</div>

## 🪄 The Magic Shell for LLMs

A powerful shell tool for running and managing llama.cpp models with a modern terminal interface, featuring LCP (Language model Command Processor). Rub the lamp, summon the llama, and watch your AI wishes come true! 🧞‍♂️

## ✨ Magical Features ✨

- **🚀 Easy Model Management**: Automatic discovery and smart matching of GGUF models
- **💬 Rich Chat Interface**: Beautiful markdown rendering with syntax highlighting and ANSI color support
- **🎨 Visual Hardware Profiling**: Real-time GPU/CPU resource monitoring with visual bars
- **🐳 Docker Integration**: Seamless llama.cpp server management via Docker Compose
- **📦 Multiple Backends**: Support for llama.cpp server, HuggingFace transformers (coming soon)
- **🔧 Smart Configuration**: XDG-compliant settings with sensible defaults
- **🎯 Intelligent Model Selection**: Hardware-aware model recommendations based on available resources
- **🚀 Ollama API Compatibility**: Drop-in replacement for existing Ollama clients
- **⚡ Optimized Performance**: Auto-tuned for your hardware

## 🎭 Quick Start (Say the Magic Words!)

### Prerequisites

- Python 3.11+
- Docker and Docker Compose
- pipx (for clean Python tool installation)
- NVIDIA GPU with CUDA support (optional, CPU mode available)

### Installation

```bash
# Clone the repository (with submodules!)
git clone --recursive https://github.com/aaronsb/shallama.git
cd shallama

# If you forgot --recursive, summon the submodules:
git submodule update --init --recursive

# Install pipx if you don't have it (choose one):
python3 -m pip install --user pipx      # Install pipx
# OR on Ubuntu/Debian:
sudo apt install pipx
# OR on macOS with Homebrew:
brew install pipx

# Ensure pipx is in your PATH
pipx ensurepath

# Install LCP using the magic installer (RECOMMENDED)
cd lcp-py
./install.sh    # Installs to ~/.local/bin using pipx
cd ..

# Alternative: Development install (for contributors)
# cd lcp-py
# pip install -e .
# cd ..

# Start the llama.cpp server
./start-llamacpp.sh
```

✨ **Why pipx?** It creates isolated environments for Python CLI tools, preventing dependency conflicts and keeping your system Python clean!

### Basic Usage

```bash
# List available models
lcp list

# Start a chat with automatic model selection
lcp chat

# Chat with a specific model
lcp chat --model "llama-3.2"

# View hardware capabilities
lcp profile

# Configure settings
lcp config
```

## Migration from Ollama

If you're coming from Ollama, use the migration script:

```bash
./migrate-from-ollama.sh
```

This will help you:
- Export model configurations
- Set up model directory structure
- Migrate environment settings
- Provide download instructions for GGUF models

## 🎪 Components (Inside the Magic Box)

### LCP (Language model Command Processor)

The main Python CLI tool providing:
- Interactive chat with streaming responses
- Model discovery and management
- Hardware profiling and optimization
- Rich terminal UI with markdown and ANSI color support

### Llama.cpp Server

Docker-based llama.cpp server with:
- GPU acceleration support
- Automatic model loading
- OpenAI-compatible API
- Configurable context sizes

## Project Structure

```
shallama/
├── lcp-py/                     # Python CLI package
│   └── lcp/
│       ├── ui/                 # Terminal UI components
│       ├── backends/           # Model backend implementations
│       └── config/             # Configuration management
├── models/                     # GGUF model storage
├── config/
│   └── models.yaml            # Model configuration
├── docker-compose.nvidia.yml   # NVIDIA GPU configuration
├── docker-compose.cpu.yml      # CPU-only configuration
├── docker-compose.yml          # Symlink to active config
├── start-llamacpp.sh           # Server startup script
├── llamacpp                    # Helper script
└── migrate-from-ollama.sh      # Migration tool from Ollama
```

## 🔮 Configuration

Shallama follows XDG Base Directory specification:
- Config: `~/.config/lcp/config.yaml`
- Cache: `~/.cache/lcp/`
- Data: `~/.local/share/lcp/`

### Example Configuration

```yaml
backend:
  default: llamacpp
  llamacpp:
    host: localhost
    port: 8080
    
ui:
  theme: monokai
  markdown:
    code_theme: monokai
    show_locals: true
    
models:
  directory: ./models
  auto_download: false
```

## Hardware Optimization

This setup is optimized for:
- **CPU**: Intel i9-14900K (24 cores, 32 threads)
- **GPU**: RTX 4060 Ti (16GB VRAM)
- **RAM**: 125GB system memory

### Performance Settings

**GPU Mode (NVIDIA)**:
- GPU layers: 999 (auto-detect optimal)
- Context length: 8192 tokens
- Parallel requests: 4
- Memory limit: 32GB

**CPU Mode**:
- Threads: 24 (optimized for i9-14900K)
- Context length: 16384 tokens
- Parallel requests: 2
- Memory limit: 64GB

## Usage

### Container Management

```bash
# Start with auto-detection
./start-llamacpp.sh

# Check status
./llamacpp status

# View logs
./llamacpp logs

# Restart container
./llamacpp restart

# Stop container
./llamacpp stop
```

### Model Management

```bash
# List available models
./llamacpp list

# Test API connection
./llamacpp test

# Get help
./llamacpp help
```

### API Usage

The API is compatible with Ollama endpoints:

```bash
# List models
curl http://localhost:11434/api/tags

# Generate text
curl -X POST http://localhost:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3-8b",
    "prompt": "Why is the sky blue?",
    "stream": false
  }'

# Chat completion (OpenAI-compatible)
curl -X POST http://localhost:11434/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3-8b",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## Model Configuration

Edit `./config/models.yaml` to configure your models:

```yaml
models:
  llama3-8b:
    path: "/models/llama-3-8b-instruct.Q4_K_M.gguf"
    n_gpu_layers: 35      # GPU layers (adjust for your model)
    n_ctx: 8192           # Context length
    temperature: 0.7      # Sampling temperature
    
  phi4-14b:
    path: "/models/phi-4.Q4_K_M.gguf"
    n_gpu_layers: 40
    n_ctx: 16384
    temperature: 0.8

default_model: "llama3-8b"
```

## Adding Models

1. **Download GGUF models** to the `./models/` directory:
   - From [Hugging Face](https://huggingface.co/models?library=gguf)
   - Using `huggingface-hub` CLI tool
   - Convert existing models with llama.cpp tools

2. **Update configuration** in `./config/models.yaml`

3. **Restart container** to load new models:
   ```bash
   ./llamacpp restart
   ```

## Troubleshooting

### GPU Issues

1. **NVIDIA GPU not detected**:
   ```bash
   # Check NVIDIA drivers
   nvidia-smi
   
   # Check Docker GPU support
   docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
   ```

2. **Container using CPU instead of GPU**:
   - Verify NVIDIA Container Toolkit installation
   - Check Docker daemon configuration
   - Restart Docker service

### Performance Issues

1. **Slow inference**:
   - Increase `n_gpu_layers` in model config
   - Check GPU memory usage with `nvidia-smi`
   - Reduce `n_ctx` if running out of memory

2. **Out of memory errors**:
   - Reduce `n_gpu_layers` or `n_ctx`
   - Use quantized models (Q4_K_M, Q5_K_M)
   - Switch to CPU mode for large models

### Container Issues

1. **Container won't start**:
   ```bash
   # Check logs
   docker compose logs llamacpp
   
   # Check Docker resources
   docker system df
   ```

2. **API not responding**:
   ```bash
   # Test container health
   docker compose ps
   
   # Check port binding
   ss -tlnp | grep 11434
   ```

## Environment Variables

Key environment variables (set in docker-compose files):

- `CUDA_VISIBLE_DEVICES`: GPU selection
- `LLAMA_CPP_N_THREADS`: CPU thread count
- `LLAMA_CPP_N_GPU_LAYERS`: GPU layer count
- `LLAMA_CPP_N_CTX`: Context length
- `LLAMA_CPP_HOST`: Bind address
- `LLAMA_CPP_PORT`: Internal port

## Comparison with Ollama

| Feature | LlamaCP | Ollama |
|---------|---------|---------|
| Base Engine | llama.cpp | llama.cpp |
| API Compatibility | Ollama + OpenAI | Ollama |
| Model Format | GGUF | Ollama format |
| GPU Support | NVIDIA, CPU | NVIDIA, AMD, CPU |
| Performance | Direct llama.cpp | Optimized wrapper |
| Model Management | Manual + Config | Built-in |
| Memory Usage | Lower overhead | Higher overhead |

## 🪄 Development

### Installation Methods

#### For Users (Recommended)
```bash
cd lcp-py
./install.sh      # Uses pipx to install to ~/.local/bin
```

#### For Developers
```bash
cd lcp-py
pip install -e .  # Editable install for development
```

#### For Contributors
```bash
cd lcp-py
./dev-install.sh  # Sets up full development environment with venv
```

### Running Tests

```bash
cd lcp-py
pytest tests/
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Areas for Contribution

1. **Additional backends**: Ollama, vLLM, TGI integration
2. **UI enhancements**: Themes, layouts, visual effects
3. **Model management**: Auto-download, conversion tools
4. **Performance**: Optimization for different hardware

## License

MIT License - see LICENSE file for details

## 🎭 Meet Our Magical Inspiration

<div align="center">
  <img src="jambi.jpg" alt="Jambi the Genie" width="250"/>
  <br>
  <em>"Meka-leka-hi-meka-hiney-ho! Your wish is granted!" - Jambi</em>
</div>

### The Spirit of Jambi Lives On! 🧞

Shallama is inspired by Jambi the Genie from Pee-wee's Playhouse, who taught us that with the right magic words, anything is possible! Just as Jambi granted wishes from his box, our magical llama grants your AI wishes from the command line.

Every time you run `lcp chat`, remember you're summoning a genie - but instead of "Meka-leka-hi-meka-hiney-ho", you're typing commands that bring AI magic to life! ✨

## 🌟 Acknowledgments

### Special Thanks
- **Jambi the Genie** 🧞 - For teaching us the power of magic words
- **The magical llama** 🦙 - Emerging from the lamp to grant AI wishes

- [llama.cpp](https://github.com/ggerganov/llama.cpp) - High-performance C++ inference
- [Rich](https://github.com/Textualize/rich) - Beautiful terminal formatting
- [Typer](https://github.com/tiangolo/typer) - Modern CLI framework
- [GGUF Models on Hugging Face](https://huggingface.co/models?library=gguf)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)