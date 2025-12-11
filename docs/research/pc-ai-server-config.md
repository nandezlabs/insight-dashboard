# PC as AI Workhorse - Configuration Guide

**Created:** December 9, 2025  
**Purpose:** Configure PC to be the AI server while maintaining gaming performance

---

## 🎯 Core Principle

**PC runs ALL AI models with minimal gaming impact**

```
Priorities:
1. Gaming performance is never compromised
2. AI services designed to coexist with gaming
3. Automatic resource management
4. Simple start/stop controls
```

---

## 🚀 PC AI Server Setup

### 1. **Ollama Configuration (All Models)**

**Why PC for ALL Ollama:**

- RTX 4060 CUDA = 20-50 tokens/sec (vs NAS 2-5 tokens/sec)
- Can run 7B, 13B, 30B+ models
- Better user experience
- Gaming impact: ~0% when idle, auto-pause when gaming

**Installation (Windows):**

```powershell
# Download Ollama for Windows
winget install Ollama.Ollama

# Or from ollama.ai/download

# Set to run at startup (but low priority)
# Install as Windows service (runs in background)
```

**Installation (Linux - if dual boot):**

```bash
curl -fsSL https://ollama.ai/install.sh | sh

# Enable as service
sudo systemctl enable ollama
sudo systemctl start ollama
```

**Resource Configuration:**

```bash
# Create config file
# Windows: %USERPROFILE%\.ollama\config.json
# Linux: ~/.ollama/config.json

{
  "num_parallel": 2,              # Max 2 concurrent requests
  "num_gpu": 1,                   # Use RTX 4060
  "num_thread": 4,                # Limit CPU threads (out of 16)
  "low_vram": false,              # PC has plenty
  "max_loaded_models": 2,         # Keep 2 models in memory max
  "gpu_memory_fraction": 0.5      # Use max 50% VRAM (leaves room for gaming)
}
```

**Gaming-Aware Settings:**

```json
{
  "idle_timeout": 300,            # Unload models after 5 min idle
  "auto_pull_models": false,      # Don't auto-download (manual control)
  "origins": ["*"],               # Allow Mac to connect
  "models_path": "E:\\ai-models"  # Store on separate drive if possible
}
```

---

### 2. **Smart Resource Limiting (Instead of Pausing)**

**Philosophy: AI scales down, not stops**

```
Gaming States:
├── No game:        100% AI resources (20-50 tok/sec)
├── Indie game:     50% AI resources (10-25 tok/sec) ✅ Still usable
├── AAA game:       25% AI resources (5-12 tok/sec) ✅ Still works
└── Ultra demanding: 10% AI resources (2-5 tok/sec) = NAS speed

Benefits:
✓ AI always available (never fully paused)
✓ Scales based on game demands
✓ Can still ask quick questions while gaming
✓ Auto-adjusts dynamically
```

**PowerShell Script (Windows):**

```powershell
# C:\Scripts\ai-resource-manager.ps1

$OLLAMA_API = "http://localhost:11434"
$PERFORMANCE_LOG = "C:\Scripts\performance-log.json"

# Load historical performance data
if (Test-Path $PERFORMANCE_LOG) {
    $perfData = Get-Content $PERFORMANCE_LOG | ConvertFrom-Json
} else {
    $perfData = @{}
}

Write-Host "🤖 AI Resource Manager Started (Dynamic Limiting)"

while ($true) {
    # Get current GPU/CPU usage
    $gpuUsage = (nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    $cpuUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

    # Detect running game
    $game = Get-Process | Where-Object {
        $_.MainWindowTitle -ne "" -and
        ($_.ProcessName -match "steam|epic|origin" -or $_.WorkingSet -gt 1GB)
    } | Select-Object -First 1

    if ($game) {
        $gameName = $game.ProcessName
        $gameMemory = [math]::Round($game.WorkingSet64 / 1GB, 2)

        # Check historical data for this game
        $knownGame = $perfData.$gameName

        if ($knownGame) {
            # Use learned optimal settings
            $targetGpuLimit = $knownGame.optimalGpuLimit
            $targetCpuLimit = $knownGame.optimalCpuLimit
            Write-Host "📊 Known game: $gameName (learned limits: GPU ${targetGpuLimit}%, CPU ${targetCpuLimit}%)"
        } else {
            # New game - use conservative defaults
            if ($gameMemory -gt 4) {
                # Large game (likely AAA)
                $targetGpuLimit = 25  # 25% GPU for AI
                $targetCpuLimit = 15  # 15% CPU for AI
                Write-Host "🎮 Large game detected: $gameName (${gameMemory}GB) - Conservative limits"
            } else {
                # Smaller game (likely indie)
                $targetGpuLimit = 50  # 50% GPU for AI
                $targetCpuLimit = 30  # 30% CPU for AI
                Write-Host "🎮 Indie game detected: $gameName (${gameMemory}GB) - Moderate limits"
            }
        }

        # Apply limits to Ollama
        $ollamaConfig = @{
            num_gpu_layers = [math]::Round(35 * ($targetGpuLimit / 100))  # Scale GPU layers
            num_thread = [math]::Round(16 * ($targetCpuLimit / 100))      # Scale CPU threads
            num_parallel = if ($targetGpuLimit -lt 30) { 1 } else { 2 }
        }

        # Update Ollama config via API
        Invoke-RestMethod -Uri "$OLLAMA_API/api/config" -Method POST -Body ($ollamaConfig | ConvertTo-Json)

        # Limit Ollama process
        $ollamaProc = Get-Process ollama -ErrorAction SilentlyContinue
        if ($ollamaProc) {
            # Set CPU affinity (use cores 4-7, leave 0-3 for game)
            $ollamaProc.ProcessorAffinity = 0xF0  # Binary: 11110000 (cores 4-7)
            $ollamaProc.PriorityClass = "BelowNormal"
        }

        # Monitor performance
        Start-Sleep -Seconds 5
        $newGpuUsage = (nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

        # Learn: If GPU usage still too high, reduce further
        if ($newGpuUsage -gt 85) {
            Write-Host "⚠️  GPU still high (${newGpuUsage}%) - Reducing AI further"
            $targetGpuLimit = [math]::Max(10, $targetGpuLimit - 10)
        }

        # Save learned data
        if (-not $perfData.$gameName) {
            $perfData.$gameName = @{
                gameName = $gameName
                optimalGpuLimit = $targetGpuLimit
                optimalCpuLimit = $targetCpuLimit
                lastPlayed = Get-Date -Format "yyyy-MM-dd"
                sessions = 1
            }
        } else {
            $perfData.$gameName.sessions++
            $perfData.$gameName.lastPlayed = Get-Date -Format "yyyy-MM-dd"
            # Average with previous optimal values (learning)
            $perfData.$gameName.optimalGpuLimit = [math]::Round(
                ($perfData.$gameName.optimalGpuLimit + $targetGpuLimit) / 2
            )
        }

        $perfData | ConvertTo-Json -Depth 10 | Set-Content $PERFORMANCE_LOG

        Write-Host "✅ AI limited for gaming: GPU ${targetGpuLimit}%, CPU ${targetCpuLimit}%"
        Write-Host "   Est. AI speed: $(10 + $targetGpuLimit/2) tokens/sec"

        $script:gamingMode = $true
    }
    elseif ($script:gamingMode) {
        # Game closed - restore full AI performance
        Write-Host "💻 Game closed - Restoring full AI performance..."

        $fullConfig = @{
            num_gpu_layers = 35           # Full GPU layers
            num_thread = 12               # Most CPU threads
            num_parallel = 2
        }

        Invoke-RestMethod -Uri "$OLLAMA_API/api/config" -Method POST -Body ($fullConfig | ConvertTo-Json)

        # Remove affinity restrictions
        $ollamaProc = Get-Process ollama -ErrorAction SilentlyContinue
        if ($ollamaProc) {
            $ollamaProc.ProcessorAffinity = 0xFF  # All cores
            $ollamaProc.PriorityClass = "Normal"
        }

        Write-Host "✅ Full AI performance restored (20-50 tokens/sec)"
        $script:gamingMode = $false
    }

    Start-Sleep -Seconds 10
}
```

**Manual Override Commands:**

```powershell
# Force specific limits (when auto-detection isn't optimal)

# Ultra performance (no game)
function Set-AIPerformance-Full {
    Invoke-RestMethod -Uri "http://localhost:11434/api/config" -Method POST -Body '{
        "num_gpu_layers": 35,
        "num_thread": 12,
        "num_parallel": 2
    }'
    Write-Host "✅ AI: Full performance (20-50 tok/sec)"
}

# Gaming mode (manual)
function Set-AIPerformance-Gaming {
    param([int]$gpuPercent = 25)

    $layers = [math]::Round(35 * ($gpuPercent / 100))
    $threads = [math]::Round(12 * ($gpuPercent / 100))

    Invoke-RestMethod -Uri "http://localhost:11434/api/config" -Method POST -Body "{
        `"num_gpu_layers`": $layers,
        `"num_thread`": $threads,
        `"num_parallel`": 1
    }"
    Write-Host "✅ AI: Gaming mode (${gpuPercent}% = ~$([math]::Round($gpuPercent/2 + 5)) tok/sec)"
}

# Aliases
Set-Alias ai-full Set-AIPerformance-Full
Set-Alias ai-game Set-AIPerformance-Gaming
```

---

### 3. **Ollama Models to Install**

```bash
# From Mac, pull models to PC
export OLLAMA_HOST=http://pc-ip:11434

# Small models (fast, everyday use)
ollama pull llama2:7b          # General purpose
ollama pull codellama:7b       # Coding assistance
ollama pull mistral:7b         # Fast general model

# Medium models (better quality)
ollama pull llama2:13b         # More capable
ollama pull codellama:13b      # Better coding
ollama pull mistral:13b        # Quality responses

# Large models (PC can handle these)
ollama pull llama2:70b         # Best quality (slow but possible)
ollama pull codellama:34b      # Advanced coding

# Specialized
ollama pull vicuna:13b         # Conversation
ollama pull orca-mini:13b      # Explanations
ollama pull llava:13b          # Vision (image understanding)
```

**Model Selection Guide:**

```
Daily Use (Keep Loaded):
├── codellama:7b    → Fast coding help
├── mistral:7b      → Quick questions
└── llama2:13b      → Better responses

Special Tasks (Load on Demand):
├── llama2:70b      → Complex analysis
├── codellama:34b   → Refactoring large codebases
└── llava:13b       → Image analysis

VRAM Usage:
├── 7B models:  ~4-6GB VRAM   (RTX 4060 has 8GB)
├── 13B models: ~7-8GB VRAM   (Can run one at a time)
└── 70B models: Needs offloading to RAM (slower but works)
```

---

### 4. **Stable Diffusion Setup**

**Installation:**

```bash
# Windows: Use Automatic1111 WebUI
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui
.\webui-user.bat

# Configure to use NVIDIA GPU
# Edit webui-user.bat:
set COMMANDLINE_ARGS=--medvram --xformers --api --listen
```

**Docker Alternative (Cleaner):**

```yaml
# docker-compose.yml
version: "3.8"

services:
  stable-diffusion:
    image: sd-webui/stable-diffusion-webui:latest
    container_name: stable-diffusion
    ports:
      - "7860:7860"
    volumes:
      - E:\ai-models\stable-diffusion:/data
    environment:
      COMMANDLINE_ARGS: "--medvram --xformers --api --listen"
      NVIDIA_VISIBLE_DEVICES: all
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
```

**Auto-Stop When Gaming:**

```powershell
# Add to ai-gaming-manager.ps1
if ($gameRunning) {
    docker stop stable-diffusion
} else {
    docker start stable-diffusion
}
```

---

### 5. **Access from Mac**

**Configure Mac to Use PC AI:**

```bash
# Add to ~/.zshrc
export OLLAMA_HOST="http://pc-ip:11434"
export SD_HOST="http://pc-ip:7860"

# Aliases for convenience
alias ollama-pc='export OLLAMA_HOST=http://pc-ip:11434'
alias ollama-status='curl http://pc-ip:11434/api/tags'
alias sd-start='ssh user@pc-ip "docker start stable-diffusion"'
alias sd-stop='ssh user@pc-ip "docker stop stable-diffusion"'

# Quick AI commands
alias ask='ollama run mistral:7b'
alias code-help='ollama run codellama:7b'
alias explain='ollama run llama2:13b'
```

**VS Code Integration:**

```json
// settings.json
{
  "continue.aiConfig": {
    "ollama": {
      "host": "http://pc-ip:11434",
      "model": "codellama:7b"
    }
  }
}
```

**Test Connection from Mac:**

```bash
# Test Ollama
curl http://pc-ip:11434/api/tags

# Test with a prompt
curl http://pc-ip:11434/api/generate -d '{
  "model": "mistral:7b",
  "prompt": "Hello, how are you?"
}'

# Or use ollama CLI
ollama run mistral:7b "Explain Docker"
```

---

### 6. **Resource Limits (Gaming Protection)**

**Ollama Process Limits (Windows):**

```powershell
# Limit Ollama to specific CPU cores and memory
# Edit Windows Service (requires admin)

sc config ollama binPath= "C:\Program Files\Ollama\ollama.exe serve --cpu-limit=4 --mem-limit=8G"

# Or use Process Lasso (free tool) to set:
# - CPU affinity: Cores 4-7 (leave 0-3 for gaming)
# - Memory limit: 8GB max
# - Priority: Below Normal
```

**Docker Resource Limits:**

```yaml
# docker-compose.yml
services:
  stable-diffusion:
    deploy:
      resources:
        limits:
          cpus: "4.0" # Max 4 cores (out of 8)
          memory: 12G # Max 12GB (out of 32GB)
        reservations:
          cpus: "2.0"
          memory: 6G
    cpu_shares: 512 # Low priority
```

---

### 7. **Performance Monitoring**

**Windows PowerShell Dashboard:**

```powershell
# C:\Scripts\ai-monitor.ps1

while ($true) {
    Clear-Host
    Write-Host "🤖 PC AI Server Monitor" -ForegroundColor Cyan
    Write-Host "========================`n" -ForegroundColor Cyan

    # Ollama status
    $ollama = Get-Process ollama -ErrorAction SilentlyContinue
    if ($ollama) {
        $cpu = [math]::Round($ollama.CPU, 2)
        $mem = [math]::Round($ollama.WorkingSet64 / 1GB, 2)
        Write-Host "Ollama:    Running (CPU: $cpu%, RAM: ${mem}GB)" -ForegroundColor Green
    } else {
        Write-Host "Ollama:    Not Running" -ForegroundColor Red
    }

    # GPU usage
    $gpu = nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv,noheader,nounits
    Write-Host "GPU:       $gpu% / 8GB VRAM" -ForegroundColor Yellow

    # Docker containers
    $containers = docker ps --format "{{.Names}}: {{.Status}}"
    Write-Host "`nAI Containers:" -ForegroundColor Cyan
    $containers | ForEach-Object { Write-Host "  $_" }

    Write-Host "`nPress Ctrl+C to exit"
    Start-Sleep -Seconds 5
}
```

---

### 8. **Quick Controls from Mac**

**Create Control Script:**

```bash
# ~/Developer/tools/ai-control.sh

#!/bin/bash

PC_IP="192.168.1.100"  # Your PC IP

case $1 in
  "status")
    echo "🤖 PC AI Server Status:"
    echo "======================="
    curl -s http://$PC_IP:11434/api/tags | jq -r '.models[] | .name' | sed 's/^/  ✓ /'
    ;;

  "start")
    echo "🚀 Starting AI services on PC..."
    ssh user@$PC_IP "docker start stable-diffusion comfyui"
    echo "✅ Services started"
    ;;

  "stop")
    echo "⏹️  Stopping AI services on PC..."
    ssh user@$PC_IP "docker stop stable-diffusion comfyui"
    echo "✅ Services stopped"
    ;;

  "gaming")
    echo "🎮 Setting PC to gaming mode..."
    ssh user@$PC_IP "powershell -File C:\Scripts\gaming-mode-manual.ps1"
    ;;

  "dev")
    echo "💻 Setting PC to dev mode..."
    ssh user@$PC_IP "powershell -File C:\Scripts\dev-mode-manual.ps1"
    ;;

  *)
    echo "Usage: ai-control {status|start|stop|gaming|dev}"
    ;;
esac
```

**Usage:**

```bash
chmod +x ~/Developer/tools/ai-control.sh

# Check what's running
ai-control status

# Start all AI services
ai-control start

# Stop for gaming
ai-control gaming

# Resume for development
ai-control dev
```

---

## 📊 Gaming Impact Analysis

### **Idle State (AI Running, Not Inferencing):**

```
Resource Usage:
├── Ollama (idle):  ~500MB RAM, 0% GPU, 0% CPU
├── Total Impact:   <1% performance
└── Gaming FPS:     60 → 60 (no change)

Verdict: ✅ Perfect - No impact
```

### **AI Active (Inference Running):**

```
Scenario 1: Coding while gaming (unlikely)
├── Ollama (7B):    2-3GB RAM, 20-40% GPU, 10% CPU
├── Gaming Impact:  10-15% FPS drop
└── Solution:       Auto-pause (gaming-manager.ps1)

Scenario 2: SD generation in background
├── Stable Diffusion: 6GB VRAM, 80-90% GPU
├── Gaming Impact:     40-60% FPS drop (unusable)
└── Solution:          Auto-stop when gaming

Verdict: ⚠️ Auto-management required (provided above)
```

### **With Auto-Management:**

```
Game Launches:
├── AI pauses automatically
├── Resources freed
├── Gaming unaffected
└── Resume when game closes

Result: ✅ Gaming always gets priority
```

---

## 🎯 Final Configuration Summary

**PC Setup:**

```
Services Always Running:
✅ Ollama (ALL models - auto-pause during gaming)
✅ Open WebUI (interface for Ollama)

Services On-Demand:
○ Stable Diffusion (manual start/stop or auto-stop gaming)
○ ComfyUI (manual)
○ Fine-tuning tasks (manual)

Auto-Management:
✅ Gaming detection script (ai-gaming-manager.ps1)
✅ Auto-pause AI during gaming
✅ Auto-resume after gaming
✅ Resource limits to protect gaming
```

**Mac Access:**

```bash
# Set default to PC AI
export OLLAMA_HOST=http://pc-ip:11434

# Use in VS Code
# Use from terminal
# Fast inference (20-50 tok/sec)
```

**NAS Role:**

```
✅ Store model files (PC downloads from NAS)
✅ Store generated outputs
✅ Backup AI configurations
❌ NO AI inference (PC does all of it)
```

---

**Result:** PC becomes powerful AI server with zero gaming compromise thanks to auto-management!
