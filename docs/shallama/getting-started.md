# 🎭 Getting Started with Shallama

Welcome to the magical world of Shallama! Let's get you up and running with your own AI genie! ✨

## 📦 Prerequisites

Before we can grant your wishes, you'll need:

- 🐳 Docker and Docker Compose
- 🐍 Python 3.11 or higher  
- 💾 At least 8GB of RAM (16GB+ recommended)
- 🎮 NVIDIA GPU with CUDA support (optional but recommended)
- ✨ A sense of wonder!

## 🪄 Installation

### Step 1: Summon Shallama

```bash
# Clone with all the magic (including LCP submodule)
git clone --recursive https://github.com/aaronsb/shallama.git
cd shallama
```

### Step 2: Prepare Your Models

Place your GGUF model files in the `models/` directory:

```bash
# Example: Download a model
cd models/
wget https://huggingface.co/[model-path]/resolve/main/model.gguf
cd ..
```

### Step 3: Configure Your Magic

Edit `config/models.yaml` to register your models:

```yaml
models:
  my-llama:
    path: "/models/llama-3.2-3b-instruct.Q4_K_M.gguf"
    n_gpu_layers: 35
    n_ctx: 8192
    
default_model: "my-llama"
```

### Step 4: Start the Magic Show! 

```bash
# The script auto-detects GPU and starts the appropriate configuration
./start-llamacpp.sh
```

You should see:
```
✨ Starting llama.cpp server...
🎭 GPU detected: NVIDIA RTX 4060 Ti
🪄 Container 'llamacpp' is now running!
```

## 🎪 Installing LCP (The Command Line Genie)

LCP is your interface to chat with the models:

```bash
# Enter the LCP directory
cd lcp-py

# Install in development mode
pip install -e .

# Or use the magic installer
./dev-install.sh
```

## 🌟 Your First Conversation

```bash
# List available models
lcp list

# Start chatting!
lcp chat

# Or specify a model
lcp chat --model "my-llama"
```

## 🎯 Quick Commands

| Command | What it does | Magic Level |
|---------|--------------|-------------|
| `./start-llamacpp.sh` | Starts the server | ⭐ |
| `lcp chat` | Opens chat interface | ⭐⭐ |
| `lcp profile` | Shows hardware capabilities | ⭐⭐ |
| `lcp list` | Lists available models | ⭐ |
| `docker compose logs -f` | Watch the magic happen | ⭐⭐⭐ |

## 🔮 What's Next?

- Configure your models: [Model Management](./models.md)
- Customize the UI: [LCP Configuration](../lcp/configuration.md)
- Optimize performance: [Docker Configuration](./docker-config.md)

## 🆘 Need Help?

If the magic isn't working:

1. Check Docker is running: `docker ps`
2. Verify GPU (if applicable): `nvidia-smi`
3. Check logs: `docker compose logs llamacpp`
4. Consult Jambi (or open an issue on GitHub!)

Remember: **"Meka-leka-hi-meka-hiney-ho!"** - Your wish is granted! ✨