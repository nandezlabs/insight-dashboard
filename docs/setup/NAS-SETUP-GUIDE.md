# UGREEN NASync DXP4800 Plus - Complete Setup Guide

**NAS Model**: UGREEN NASync DXP4800 Plus  
**Capacity**: ~16TB  
**Purpose**: Personal storage, backups, development, AI models  
**Philosophy**: Open-source first

---

## 📋 Table of Contents

1. [Initial Setup](#initial-setup)
2. [Storage Configuration](#storage-configuration)
3. [Personal Use Setup](#personal-use-setup)
4. [Development Environment](#development-environment)
5. [AI/ML Workloads](#aiml-workloads)
6. [Backup Automation](#backup-automation)
7. [Workflow Integration](#workflow-integration)

---

## 1. Initial Setup

### Hardware Connection

1. Connect NAS to network via Ethernet (gigabit recommended)
2. Power on and access via http://NAS-IP-ADDRESS
3. Complete initial setup wizard

### Basic Configuration

```bash
# Find NAS IP (from your Mac)
arp -a | grep ugreen

# Or use UGREEN app to find IP
# Access web interface: http://192.168.X.X:5000
```

### Create Admin Account

- **Username**: Your choice (recommend: nandez-admin)
- **Password**: Strong password (store in password manager)
- Enable 2FA if available

---

## 2. Storage Configuration

### Recommended RAID Setup (16TB)

**Option A: RAID 5 (Recommended for you)**

- **Usable**: ~12TB
- **Redundancy**: 1 disk can fail
- **Best for**: Balance of storage + protection

**Option B: RAID 1**

- **Usable**: ~8TB
- **Redundancy**: 50% mirror
- **Best for**: Maximum protection

**My Recommendation**: RAID 5 (12TB usable, 1-disk fault tolerance)

### Storage Layout

```
/volume1/                          [12TB usable]
├── backups/                       [4TB]
│   ├── mac-backups/              (Time Machine)
│   ├── code-repos/               (Git backups)
│   └── vscode-settings/          (VS Code backups)
├── development/                   [4TB]
│   ├── docker/                   (Container data)
│   ├── databases/                (PostgreSQL, MongoDB)
│   ├── git-server/               (Gitea/GitLab)
│   └── projects/                 (Project files)
├── ai-models/                     [2TB]
│   ├── llm-models/               (LLaMA, Mistral)
│   ├── stable-diffusion/         (SD models)
│   └── datasets/                 (Training data)
├── personal/                      [1TB]
│   ├── documents/
│   ├── photos/
│   └── media/
└── services/                      [1TB]
    ├── nextcloud/                (File sync)
    ├── monitoring/               (Grafana, Prometheus)
    └── automation/               (n8n, HomeAssistant)
```

---

## 3. Personal Use Setup

### A. Time Machine Backup (Mac)

**On NAS:**

1. Install "Time Machine" package (if available)
2. Create shared folder: `/volume1/backups/mac-backups`
3. Enable AFP or SMB protocol

**On Mac:**

```bash
# Connect to NAS as Time Machine destination
# System Preferences → Time Machine → Select Backup Disk
# Choose: smb://NAS-IP/mac-backups
```

### B. File Sync (Nextcloud)

**Why Nextcloud?**

- Open-source alternative to Dropbox/iCloud
- Full control over your data
- Mobile apps available

**Installation:**

```bash
# Via Docker (recommended)
# See Docker setup section below
```

### C. Photo Management (PhotoPrism)

**Open-source Google Photos alternative**

```yaml
# docker-compose.yml for PhotoPrism
version: "3.8"
services:
  photoprism:
    image: photoprism/photoprism:latest
    ports:
      - "2342:2342"
    volumes:
      - /volume1/personal/photos:/photoprism/originals
      - /volume1/services/photoprism:/photoprism/storage
    environment:
      PHOTOPRISM_ADMIN_PASSWORD: "your-password"
```

---

## 4. Development Environment

### A. Docker Installation

**Install Docker on NAS:**

```bash
# SSH into NAS
ssh admin@NAS-IP

# Install Docker (if not pre-installed)
# Check UGREEN app store for Docker package
# Or install manually:
wget -qO- https://get.docker.com/ | sh
```

### B. Development Services Stack

**docker-compose.yml** for development:

```yaml
version: "3.8"

services:
  # Git Server (Gitea - lightweight GitHub alternative)
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    ports:
      - "3000:3000"
      - "2222:22"
    volumes:
      - /volume1/development/git-server:/data
    environment:
      - USER_UID=1000
      - USER_GID=1000
    restart: always

  # PostgreSQL Database
  postgres:
    image: postgres:16
    container_name: postgres
    ports:
      - "5432:5432"
    volumes:
      - /volume1/development/databases/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: your-secure-password
      POSTGRES_USER: nandez
      POSTGRES_DB: devdb
    restart: always

  # MongoDB
  mongodb:
    image: mongo:7
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - /volume1/development/databases/mongodb:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: nandez
      MONGO_INITDB_ROOT_PASSWORD: your-secure-password
    restart: always

  # Redis (caching)
  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - /volume1/development/databases/redis:/data
    restart: always

  # Code Server (VS Code in browser)
  code-server:
    image: codercom/code-server:latest
    container_name: code-server
    ports:
      - "8080:8080"
    volumes:
      - /volume1/development/projects:/home/coder/projects
      - /volume1/development/code-server:/home/coder/.local/share/code-server
    environment:
      PASSWORD: your-password
    restart: always

  # Portainer (Docker management UI)
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /volume1/development/portainer:/data
    restart: always
```

### C. CI/CD Pipeline (Drone CI)

**Open-source alternative to GitHub Actions**

```yaml
drone:
  image: drone/drone:latest
  container_name: drone
  ports:
    - "8081:80"
  volumes:
    - /volume1/development/drone:/data
  environment:
    DRONE_GITEA_SERVER: http://gitea:3000
    DRONE_RPC_SECRET: your-rpc-secret
    DRONE_SERVER_HOST: nas-ip:8081
  restart: always
```

---

## 5. AI/ML Workloads

### A. Text Generation (Ollama)

**Run LLaMA, Mistral, CodeLlama locally**

```yaml
ollama:
  image: ollama/ollama:latest
  container_name: ollama
  ports:
    - "11434:11434"
  volumes:
    - /volume1/ai-models/ollama:/root/.ollama
  restart: always
  # Requires GPU passthrough if available
```

**Usage from your Mac:**

```bash
# Install Ollama client on Mac
brew install ollama

# Configure to use NAS
export OLLAMA_HOST=http://NAS-IP:11434

# Pull models
ollama pull llama2
ollama pull codellama
ollama pull mistral

# Run inference
ollama run llama2 "Write a Python function"
```

### B. Image Generation (Stable Diffusion WebUI)

```yaml
stable-diffusion:
  image: sd-webui/stable-diffusion-webui:latest
  container_name: stable-diffusion
  ports:
    - "7860:7860"
  volumes:
    - /volume1/ai-models/stable-diffusion:/data
  environment:
    COMMANDLINE_ARGS: "--medvram --xformers"
  restart: always
```

### C. Open WebUI (ChatGPT-like interface for local models)

```yaml
open-webui:
  image: ghcr.io/open-webui/open-webui:main
  container_name: open-webui
  ports:
    - "3001:8080"
  volumes:
    - /volume1/ai-models/open-webui:/app/backend/data
  environment:
    OLLAMA_BASE_URL: http://ollama:11434
  restart: always
```

### D. Jupyter Lab (AI/ML Development)

```yaml
jupyterlab:
  image: jupyter/datascience-notebook:latest
  container_name: jupyterlab
  ports:
    - "8888:8888"
  volumes:
    - /volume1/ai-models/notebooks:/home/jovyan/work
  environment:
    JUPYTER_ENABLE_LAB: "yes"
  restart: always
```

---

## 6. Backup Automation

### A. Automated Git Backups

**Script to backup all GitHub repos to NAS:**

```bash
#!/bin/bash
# /volume1/backups/scripts/backup-github.sh

BACKUP_DIR="/volume1/backups/code-repos"
GITHUB_USER="nandezlabs"

# Get all repos
gh repo list $GITHUB_USER --limit 1000 --json name -q '.[].name' | while read repo; do
    echo "Backing up: $repo"

    if [ -d "$BACKUP_DIR/$repo" ]; then
        cd "$BACKUP_DIR/$repo" && git pull
    else
        cd "$BACKUP_DIR" && gh repo clone "$GITHUB_USER/$repo"
    fi
done

echo "✅ Backup complete: $(date)"
```

### B. VS Code Settings Sync to NAS

**Modified manage-vscode.sh:**

```bash
# Backup to NAS instead of local
BACKUP_DIR="/Volumes/nas/backups/vscode-settings"
```

### C. Automated Backup Scheduling

**Cron jobs on NAS:**

```bash
# SSH into NAS
crontab -e

# Add these lines:
# Backup GitHub repos daily at 2 AM
0 2 * * * /volume1/backups/scripts/backup-github.sh

# Backup databases daily at 3 AM
0 3 * * * /volume1/backups/scripts/backup-databases.sh

# Snapshot important folders weekly
0 4 * * 0 /volume1/backups/scripts/create-snapshot.sh
```

---

## 7. Workflow Integration

### A. Mount NAS on Mac (Persistent)

**Auto-mount at login:**

```bash
# Create mount point
mkdir -p ~/NAS

# Add to /etc/auto_master (requires sudo)
sudo echo "/Users/nandez/NAS auto_nas" >> /etc/auto_master

# Create /etc/auto_nas
sudo cat > /etc/auto_nas << EOF
development -fstype=smbfs ://nandez@NAS-IP/development
backups -fstype=smbfs ://nandez@NAS-IP/backups
ai-models -fstype=smbfs ://nandez@NAS-IP/ai-models
personal -fstype=smbfs ://nandez@NAS-IP/personal
EOF

# Restart automount
sudo automount -vc
```

**Or use Finder (simpler):**

1. Cmd+K in Finder
2. `smb://NAS-IP`
3. Check "Remember this password in keychain"
4. Drag to Login Items to auto-mount

### B. Update Workflow Scripts

**Modified create-project.sh to offer NAS storage:**

```bash
echo "Where to create project?"
echo "1) Local Mac"
echo "2) NAS (recommended for large projects)"
read -p "Select (1-2): " STORAGE_CHOICE
```

### C. Environment Variables

**Add to ~/.zshrc:**

```bash
# NAS Configuration
export NAS_IP="192.168.X.X"
export NAS_DEV="~/NAS/development"
export NAS_BACKUP="~/NAS/backups"
export NAS_AI="~/NAS/ai-models"

# Aliases
alias nas-ssh='ssh admin@$NAS_IP'
alias nas-dev='cd $NAS_DEV'
alias nas-backup='cd $NAS_BACKUP'
alias nas-ai='cd $NAS_AI'
alias nas-ollama='ollama --host http://$NAS_IP:11434'
```

---

## Next Steps

1. Initial NAS setup and RAID configuration
2. Install Docker and Portainer
3. Deploy development services stack
4. Set up Ollama for AI models
5. Configure automated backups
6. Mount NAS on Mac
7. Test workflow integration

Ready to proceed with detailed setup scripts?
