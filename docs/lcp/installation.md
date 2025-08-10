# 🎭 LCP Installation Guide

LCP (Language model Command Processor) is your magical interface to the world of LLMs! ✨

## 📦 Prerequisites

- Python 3.11+ (the magic requires modern spells)
- pip or pipx
- A running llama.cpp server (via Shallama)

## 🪄 Installation Methods

### Method 1: Development Install (Recommended for Wizards)

```bash
# From the shallama root directory
cd lcp-py

# Create a virtual environment (optional but recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install in editable mode
pip install -e .
```

### Method 2: Quick Install Script

```bash
cd lcp-py
./dev-install.sh
```

This magical script will:
- ✨ Create a virtual environment
- 🎪 Install all dependencies
- 🔮 Set up development tools
- 🎭 Configure your environment

### Method 3: Direct from GitHub

```bash
# Install directly from the repository
pip install git+https://github.com/aaronsb/lcp-py.git
```

### Method 4: Using pipx (Isolated Install)

```bash
# Install pipx if you haven't already
pip install --user pipx
pipx ensurepath

# Install LCP
pipx install git+https://github.com/aaronsb/lcp-py.git
```

## 🎯 Verify Installation

After installation, verify LCP is ready:

```bash
# Check version
lcp --version

# See available commands
lcp --help

# Test connection to llama.cpp server
lcp test
```

## 🔮 Configuration

LCP follows XDG Base Directory specification. On first run, it creates:

```
~/.config/lcp/config.yaml    # Your personal spellbook
~/.cache/lcp/                # Cached magic
~/.local/share/lcp/           # Your data vault
```

## ✨ First Run Setup

1. **Start your llama.cpp server** (if not already running):
   ```bash
   cd /path/to/shallama
   ./start-llamacpp.sh
   ```

2. **Configure LCP** to talk to your server:
   ```bash
   lcp config
   ```

3. **Test the connection**:
   ```bash
   lcp test
   ```

4. **Start chatting**:
   ```bash
   lcp chat
   ```

## 🎪 Features Available After Installation

- **`lcp chat`** - Interactive chat with streaming responses
- **`lcp list`** - See all available models
- **`lcp profile`** - Hardware profiling with visual bars
- **`lcp generate`** - One-shot text generation
- **`lcp config`** - Configure settings

## 🌟 Pro Tips

1. **Use aliases** for common commands:
   ```bash
   alias chat='lcp chat'
   alias models='lcp list'
   ```

2. **Enable rich terminal features**:
   ```bash
   export COLORTERM=truecolor
   ```

3. **Custom themes**: Edit `~/.config/lcp/config.yaml`:
   ```yaml
   ui:
     theme: monokai
     markdown:
       code_theme: dracula
   ```

## 🆘 Troubleshooting

### "Command not found"
- Make sure `~/.local/bin` is in your PATH
- Or use the full path: `~/.local/bin/lcp`

### "Connection refused"
- Verify llama.cpp server is running: `docker ps`
- Check the port: default is 8080

### "No models found"
- Ensure models are in the correct directory
- Check `config/models.yaml` in Shallama

## 🎭 What's Next?

- Learn all commands: [CLI Commands](./commands.md)
- Customize your experience: [Configuration](./configuration.md)
- Optimize for your hardware: [Hardware Profiling](./hardware.md)

Remember: With great models comes great conversation! ✨🧞‍♂️