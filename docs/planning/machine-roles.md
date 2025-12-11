# Machine Roles & Workload Distribution

**Created:** December 9, 2025

---

## 🖥️ Three-Machine Architecture

### MacBook Air M2 - Primary Development Station

**Role:** Daily driver, lightweight development, iOS/macOS focus

**Strengths:**

- Portable and battery-efficient
- Excellent for iOS/macOS development (required for Xcode)
- Fast for general coding and testing
- Good for Godot 2D development

**Limitations:**

- ⚠️ 8GB RAM (careful resource management needed)
- Cannot run heavy AI models locally
- Limited for multiple Docker containers
- Cannot handle intensive 3D game dev work

**Primary Workloads:**

- ✅ Writing code (VS Code)
- ✅ Git operations
- ✅ iOS/macOS development (Xcode)
- ✅ Godot 2D game development
- ✅ Frontend web development
- ✅ Light backend testing (single container max)
- ✅ Remote connections to PC/NAS for heavy tasks
- ❌ Heavy Docker workloads → Offload to NAS/PC
- ❌ Large AI models → Use PC or NAS (Ollama)
- ❌ Multiple databases → Connect to NAS instances
- ❌ 3D game development → Use PC

---

### Gaming/Dev PC - Gaming First, Development Second

**Role:** Primary gaming machine that CAN handle heavy dev tasks when needed

**Strengths:**

- 💪 32GB RAM (4x MacBook capacity)
- 🎮 RTX 4060 GPU (gaming + CUDA for AI/ML)
- ⚡ Ryzen 7 7700X (powerful CPU)
- 🔧 Windows + Linux dual-boot or WSL2

**Key Principle: Gaming Never Compromised**

```
✅ No persistent dev services on PC (databases, Git, etc.)
✅ Gaming should work anytime without stopping anything
✅ PC is the AI workhorse (all AI models run here)
✅ AI services designed to not impact gaming
✅ NAS handles all non-AI persistent services
✅ PC is clean and gaming-ready by default
```

**Primary Workloads:**

#### Gaming (PRIMARY Use - Always Available)

- Steam gaming library (always ready)
- Performance gaming (no background services competing)
- VR (if applicable)
- PC should boot to gaming-ready state
- Gaming has priority over all other tasks

#### AI/ML (SECONDARY - Workhorse for ALL AI)

**PC is the designated AI server for your entire setup**

**Always-Running AI Services (Low Impact on Gaming):**

- ✅ Ollama (ALL models: 7B, 13B, 30B+)
  - Configured to pause inference during gaming
  - Idle state uses minimal resources (~500MB RAM, 0% GPU)
  - Auto-resumes when gaming stops
- ✅ Text Generation WebUI
- ✅ Open WebUI (ChatGPT-like interface)

**On-Demand AI Services (Start/Stop as Needed):**

- ✅ Stable Diffusion (image generation)
- ✅ ComfyUI, Automatic1111
- ✅ Fine-tuning models
- ✅ CUDA-accelerated training
- ✅ Jupyter notebooks for AI experiments

**Why PC for ALL AI:**

- GPU acceleration (RTX 4060 CUDA)
- Fast inference (20-50 tokens/sec vs NAS 2-5)
- Can run large models (30B+)
- Better user experience from Mac
- Minimal gaming impact with proper config

#### Heavy Development Tasks (On-Demand Only)

- ✅ 3D game development (Godot, Unity if needed)
- ⚠️ Large Docker stacks → Prefer NAS (databases, etc.)
- ✅ Intensive build processes
- ✅ Video rendering/processing
- ❌ Databases → Use NAS (not PC)
- ✅ Running VMs for testing
- 📝 Run temporarily, then close

#### Remote Development Server (On-Demand Only)

- ✅ VS Code Remote SSH from Mac
- ✅ Code-server (VS Code in browser)
- ✅ Act as build server for projects
- 📝 Only when actively developing, not 24/7

**Service Philosophy:**

```
PC = AI Workhorse + Gaming Machine
├── All AI models (Ollama, SD, etc.)
├── Gaming (primary purpose)
└── Occasional heavy builds

NAS = Everything Else (24/7)
├── Databases (PostgreSQL, MongoDB, Redis)
├── Git server (Gitea)
├── CI/CD (Drone)
├── Monitoring & backups
└── File storage

Mac = Development Interface
├── Connects to NAS for databases
├── Connects to PC for AI models
├── Primary coding environment
└── iOS/macOS development

Example Workflow:
├── Coding on Mac in VS Code
├── Need AI assistance? → PC Ollama (fast, always ready)
├── Need database? → NAS PostgreSQL (always running)
├── Generate image? → PC Stable Diffusion (start/stop)
├── Want to game? → Close AI tasks, game immediately
```

**OS Configuration Options:**

**Option 1: Dual Boot (Recommended)**

```
Boot Menu:
├── Windows 11 (Gaming + WSL2)
└── Ubuntu/Pop!_OS (Pure dev environment)
```

**Option 2: Windows + WSL2 Only**

```
Windows 11
└── WSL2 Ubuntu (Development)
```

**My Recommendation:** Dual boot

- Windows for gaming + heavy AI (better GPU drivers)
- Linux for clean development environment
- Best of both worlds

---

### NAS - Always-On Infrastructure Hub

**Role:** 24/7 development services, storage (NO AI - PC handles that)

**Strengths:**

- Always available (24/7 uptime)
- Centralized storage (12TB usable)
- Low power consumption
- Network-accessible from all devices

**Storage Layout:** (Per NAS-SETUP-GUIDE.md)

```
/volume1/ [12TB]
├── backups/ [4TB]
│   ├── mac-backups/ (Time Machine)
│   ├── code-repos/ (Git backups)
│   └── vscode-settings/
├── development/ [4TB]
│   ├── docker/ (Container data)
│   ├── databases/ (PostgreSQL, MongoDB, Redis)
│   ├── git-server/ (Gitea)
│   └── projects/
├── ai-models/ [2TB]
│   ├── model-storage/ (Model files, PC downloads from here)
│   ├── datasets/ (Training data)
│   └── outputs/ (Generated images/text from PC)
├── personal/ [1TB]
└── services/ [1TB]
```

**Primary Workloads:**

#### Development Services (24/7 - Core Infrastructure)

- ✅ PostgreSQL (production-like database)
- ✅ MongoDB
- ✅ Redis (caching)
- ✅ Gitea (self-hosted Git)
- ✅ Drone CI (continuous integration)
- ✅ Portainer (Docker management)
- ✅ Code-server (backup dev environment)

#### AI Support (Storage Only - NOT Inference)

- ✅ Model file storage (PC downloads from here)
- ✅ Dataset storage (training data)
- ✅ Output storage (generated content from PC)
- ✅ Shared AI project files
- ❌ NO Ollama on NAS → All on PC
- ❌ NO AI inference → PC handles everything

#### Backup & Storage

- ✅ Time Machine backups (Mac)
- ✅ Git repository backups
- ✅ Project file storage
- ✅ Photo/document management
- ✅ Container volume persistence
- ✅ AI model archives

#### Monitoring & Automation

- ✅ Uptime Kuma (service monitoring)
- ✅ Grafana + Prometheus (metrics)
- ✅ n8n (workflow automation)
- ✅ Cron jobs (scheduled tasks)

---

## 🔄 Workflow Scenarios

### Scenario 1: Web App Development (Full-stack)

**Mac (Primary):**

- Write code in VS Code
- Frontend development (React/Next.js)
- Git commits
- Light testing with single container

**NAS (Services):**

- PostgreSQL database (connect from Mac)
- Redis cache
- Production-like environment
- Git backup via Gitea

**PC (If Needed):**

- Heavy integration testing (multiple services)
- Performance testing
- Build optimization

---

### Scenario 2: iOS App Development

**Mac (Only Option):**

- Xcode development
- Swift coding
- Simulator testing
- TestFlight distribution

**NAS (Support):**

- Backend API (if app needs server)
- Database for app
- Git repository

**PC:**

- Not used (iOS development requires macOS)

---

### Scenario 3: Game Development (Godot)

**2D Games:**
**Mac:**

- Godot development (2D runs fine)
- Scripting (GDScript/C#)
- Asset management
- Light testing

**3D Games:**
**PC:**

- Godot development (needs GPU)
- 3D scene building
- Performance testing
- Export builds for all platforms

**NAS:**

- Asset storage (large textures, models)
- Git repository
- Build artifact storage
- Automated exports via CI/CD

---

### Scenario 4: AI/ML Experimentation

**Small Models (LLaMA 7B, Mistral 7B):**
**NAS:**

- Run via Ollama
- Access from Mac browser (Open WebUI)
- Always-on availability

**Large Models (LLaMA 13B+, 30B+):**
**PC:**

- Run locally with GPU acceleration
- Faster inference
- Fine-tuning capability
- Stable Diffusion

**Mac:**

- Connect to NAS Ollama or PC remotely
- Write code that uses AI
- Test AI integrations

---

### Scenario 5: Cross-Platform Game Deployment

**Development:**

- Mac: 2D games, initial prototyping
- PC: 3D games, performance optimization

**Building:**

```
Godot Export Targets:
├── macOS → Build on Mac
├── Windows → Build on PC (or Mac with templates)
├── Linux → Build on PC (native or via Wine)
├── iOS → Build on Mac (required)
├── Android → Build on either (Mac or PC)
└── Web (HTML5) → Build on either
```

**CI/CD on NAS:**

- Automated builds via Drone CI
- Multi-platform export
- Artifact storage
- Version tagging

---

## 🎯 Optimization Strategies

### For Mac (8GB RAM Constraint)

**Memory-Saving Techniques:**

1. **Remote Development**

   - SSH to PC for heavy work
   - Use NAS databases (don't run locally)
   - Code-server on NAS as backup

2. **Docker Strategy**

   - Don't run Docker Desktop 24/7
   - Use OrbStack (lighter than Docker Desktop)
   - Max 1-2 containers at once
   - Prefer connecting to NAS services

3. **Application Management**

   - Close unused apps
   - Use Safari (more efficient than Chrome)
   - Monitor Activity Monitor
   - Use swap wisely

4. **VS Code Optimization**
   - Disable unused extensions
   - Use workspace-specific extensions
   - Remote SSH to PC for large projects
   - Use lightweight themes

### For PC (Gaming + Dev Balance)

**Dual-Boot Workflow:**

```
Windows Boot (Gaming):
- Steam library
- AI model inference (better GPU drivers)
- Stable Diffusion
- Video editing

Linux Boot (Development):
- Docker development
- Database testing
- Build processes
- Clean dev environment
```

**When to Reboot:**

- Gaming session → Windows
- Heavy dev work → Linux
- AI/ML experiments → Windows (CUDA)

**Shared Resources:**

- Shared `/home` partition (access files from both OS)
- NAS storage (accessible from both)
- Git repos on NAS (single source of truth)

### For NAS (Always-On Services)

**Resource Allocation:**

```
Critical Services (High Priority):
- PostgreSQL
- Redis
- Gitea
- Portainer

Medium Priority:
- Ollama (small models)
- Monitoring

Low Priority (Can Stop):
- Jupyter Lab
- Code-server (only when needed)
```

**Maintenance Windows:**

```
Daily: 3-5 AM
- Database backups
- Git repo backups
- Log rotation

Weekly: Sunday 4 AM
- System updates
- Docker image updates
- Storage snapshots

Monthly:
- Full system backup
- Security audits
```

---

## 📊 Resource Comparison Matrix

| Task                        | Mac            | PC             | NAS           | Notes                |
| --------------------------- | -------------- | -------------- | ------------- | -------------------- |
| **Web Frontend Dev**        | ✅ Primary     | ⚪ Optional    | ❌            | Mac is perfect       |
| **Web Backend Dev**         | ⚠️ Light only  | ✅ Heavy       | ✅ Services   | Use NAS databases    |
| **iOS Development**         | ✅ Only option | ❌             | ❌            | Requires macOS       |
| **Godot 2D**                | ✅ Primary     | ✅ Better perf | ❌            | Mac sufficient       |
| **Godot 3D**                | ❌ Limited     | ✅ Primary     | ❌            | Needs GPU            |
| **AI 7B Models**            | ❌             | ✅ Fast        | ⚠️ Slower     | NAS for convenience  |
| **AI 13B+ Models**          | ❌             | ✅ Only option | ❌            | Requires GPU         |
| **Stable Diffusion**        | ❌             | ✅ Only option | ❌            | GPU required         |
| **Docker (1-2 containers)** | ⚠️ Possible    | ✅ Easy        | ✅ 24/7       | Mac can handle light |
| **Docker (10+ containers)** | ❌             | ✅ Easy        | ⚠️ Slower     | PC preferred         |
| **Database Hosting**        | ❌             | ✅ Testing     | ✅ Production | NAS for persistent   |
| **Git Server**              | ❌             | ⚠️ Optional    | ✅ Primary    | NAS always-on        |
| **CI/CD**                   | ❌             | ⚠️ Optional    | ✅ Primary    | NAS automation       |
| **Backups**                 | ❌             | ❌             | ✅ Primary    | NAS centralized      |
| **Video Editing**           | ⚠️ Light       | ✅ Heavy       | ❌            | PC has power         |
| **Gaming**                  | ❌             | ✅ Primary     | ❌            | PC only              |

**Legend:**

- ✅ Primary/Recommended
- ⚠️ Possible but limited
- ⚪ Optional
- ❌ Not suitable

---

## 🔧 Remote Access Strategy

### Mac → PC

```bash
# SSH into PC
ssh nandez@pc-ip

# VS Code Remote SSH
# Install "Remote - SSH" extension
# Connect to PC for heavy projects

# Use PC GPU remotely
# Port forward for Jupyter: ssh -L 8888:localhost:8888 nandez@pc-ip
```

### Mac → NAS

```bash
# Mount NAS shares
~/NAS/development
~/NAS/backups
~/NAS/ai-models

# SSH into NAS
ssh admin@nas-ip

# Access web services
http://nas-ip:9000 → Portainer
http://nas-ip:3000 → Gitea
http://nas-ip:3001 → Open WebUI
```

### PC → NAS

```bash
# Linux: Mount via CIFS
sudo mount -t cifs //nas-ip/development /mnt/nas

# Windows: Map network drive
\\nas-ip\development → Z:

# Access NAS services same as Mac
```

---

## 🎮 Gaming PC Dev Setup (Detailed)

### Dual Boot Configuration

**Partition Layout (2TB):**

```
├── Windows 11 [500GB]
│   ├── C:\ (System)
│   ├── D:\ (Games - Steam library)
│   └── WSL2 Ubuntu (if using WSL)
├── Ubuntu/Pop!_OS [400GB]
│   ├── / (Root)
│   ├── /home (User data)
│   └── swap
└── Shared Data [1.1TB]
    ├── Projects (NTFS - accessible from both)
    ├── Media
    └── Downloads
```

**Boot Manager:** GRUB with Windows option

### Software Per OS

**Windows (Gaming + AI):**

```
Essential:
- Steam
- Discord
- NVIDIA Drivers (latest)
- VS Code
- Git for Windows
- Windows Terminal

AI/ML:
- Ollama for Windows
- LM Studio (user-friendly LLM interface)
- Automatic1111 (Stable Diffusion)
- ComfyUI
- CUDA Toolkit

Optional WSL2:
- Ubuntu 22.04 LTS
- Docker Desktop (if using WSL)

Development (if not using Linux boot):
- Node.js
- Python
- Visual Studio (for C# with Godot)
```

**Linux (Pure Development):**

```
Essential:
- VS Code
- Git
- Docker + Docker Compose
- Build tools (gcc, make, cmake)

Languages:
- Node.js (via nvm)
- Python 3.11+ (via pyenv)
- Go (if needed)
- Rust (if needed)

Godot:
- Godot Engine
- Blender (3D asset creation)
- GIMP (image editing)

Databases (local testing):
- PostgreSQL
- MongoDB
- Redis
- SQLite

AI (CUDA on Linux):
- Ollama
- Jupyter Lab
- PyTorch with CUDA
- TensorFlow with CUDA
```

---

## 💡 Pro Tips

### Seamless Mac ↔ PC Workflow

**Shared Git via NAS:**

```bash
# Clone once to NAS
cd ~/NAS/development
git clone https://github.com/you/project.git

# Work from Mac
cd ~/NAS/development/project
code .  # Edit in VS Code

# Continue on PC (Linux)
cd /mnt/nas/development/project
code .  # Same project, different machine
```

**Dotfiles Sync:**

```bash
# Store dotfiles on NAS
~/NAS/backups/dotfiles/
├── .zshrc
├── .bashrc
├── .gitconfig
└── .vscode/

# Symlink on both machines
ln -s ~/NAS/backups/dotfiles/.zshrc ~/.zshrc
```

### Resource Monitoring

**Mac:**

```bash
# Monitor memory pressure
memory_pressure

# Activity Monitor
# Watch for "Memory Pressure" indicator
```

**PC (Linux):**

```bash
# Install monitoring
sudo apt install htop btop

# Real-time monitoring
btop  # Beautiful terminal monitor

# GPU monitoring
nvidia-smi -l 1  # Update every second
```

**NAS:**

```bash
# Web UI monitoring
http://nas-ip:9000  # Portainer

# Grafana dashboard (if set up)
http://nas-ip:3002
```

---

## 📝 Summary: Who Does What

**Mac:** Coding, iOS dev, 2D games, Git, light testing  
**PC:** Gaming, AI models, 3D games, heavy Docker, Linux dev  
**NAS:** Databases, Git server, CI/CD, backups, always-on services

**Golden Rule:**

- Mac = Write code
- PC = Heavy computation
- NAS = Persistent services & storage

---

**Next:** Ready to create installation scripts and setup automation when you are!
