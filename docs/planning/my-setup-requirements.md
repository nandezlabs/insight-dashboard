# My Development Setup - Custom Requirements & Recommendations

**Created:** December 9, 2025  
**Developer:** Duvan Fernandez

---

## Current Hardware Inventory

### Primary Development Machine - MacBook Air M2

- **Model:** MacBook Air (2023)
- **Chip:** Apple M2 (8-core: 4 performance + 4 efficiency)
- **RAM:** 8 GB
- **OS:** macOS 26.1 (25B78)
- **Status:** ⚠️ RAM is on the lower side for full-stack development with multiple services

### Secondary Machine - Gaming/Development PC (Dual Purpose)

- **CPU:** AMD Ryzen 7 7700X (8-core, 4.5GHz)
- **GPU:** NVIDIA GeForce RTX 4060 (CUDA for AI/ML)
- **RAM:** 32GB DDR5-6000
- **Motherboard:** MSI B650-P PRO WiFi (WiFi capable)
- **Storage:** ~2TB
- **Primary Use:** Gaming (Steam) + Development
- **Dev Capabilities:**
  - Heavy AI model hosting (CUDA support)
  - Large containerized workloads
  - 3D game development (Godot)
  - Intensive builds & compilation
  - Linux development environment

### Network Storage - Ugreen NASync DXP4800 Plus

- **Type:** 4-bay NAS
- **Capacity:** ~16TB (RAID 5: ~12TB usable)
- **Architecture:** Per existing `/Users/nandez/Developer/docs/setup/NAS-SETUP-GUIDE.md`
- **Use Cases:**
  - Self-hosted development services
  - Project backups (Git, VS Code, Time Machine)
  - Databases (PostgreSQL, MongoDB, Redis)
  - Small AI models (LLaMA, Mistral via Ollama)
  - Git server (Gitea)
  - CI/CD runner (Drone)
  - Docker container hosting
- **Note:** Heavy AI workloads delegated to PC (RTX 4060)

---

## Development Focus

### Project Types

- **Web Applications** (Full-stack)
- **iOS Mobile Apps**
- **macOS Applications**
- **Cross-Platform Game Development** (Godot Engine)
- **Self-hosted Personal Projects**

### Primary Stack

- **Frontend:** React, Next.js, Vue, or similar modern frameworks
- **Backend:** Node.js, Python, or similar
- **Mobile:** Swift (iOS native) or React Native
- **Game Dev:** Godot Engine (2D/3D, cross-platform)
- **AI/ML:** Local models for development assistance
- **Deployment:** Self-hosted on NAS

### Software Preferences

- ✅ VS Code with GitHub Copilot (primary IDE)
- ✅ Godot (game development)
- ✅ macOS (primary OS)
- ✅ Open source / Free software preferred
- ✅ Open to paid options if valuable

---

## Recommended Software Stack

### Development Tools - macOS (Primary)

#### Essential (Install First)

```bash
# Package Manager
- Homebrew ✓ (likely installed)

# Version Control
- Git ✓
- GitHub CLI (gh)
- GitHub Desktop (optional GUI)

# Runtimes & Languages
- Node.js (LTS) + npm/yarn/pnpm
- Python 3.11+ (for backend/scripts)
- Swift/Xcode (for iOS/macOS development)

# Databases
- PostgreSQL (via Homebrew or Docker)
- SQLite (built-in)
- Redis (for caching)
```

#### VS Code Extensions (Already have Copilot)

```
Essential:
- GitLens (Git supercharging)
- Prettier (code formatting)
- ESLint (JavaScript linting)
- Python extension pack
- Swift extension
- Docker extension
- REST Client (API testing)
- Live Server
- Thunder Client (Postman alternative)

iOS/Mobile Development:
- Swift Language
- iOS Common Utils
- SF Symbols

Full-Stack Web:
- ES7+ React/Redux/React-Native snippets
- Tailwind CSS IntelliSense
- Auto Rename Tag
- Path Intellisense

Database:
- PostgreSQL (syntax highlighting)
- SQLite Viewer

Godot:
- godot-tools (GDScript support)
```

#### Containerization & Virtualization

```bash
- Docker Desktop for Mac (essential for self-hosting)
- Orbstack (lighter alternative to Docker Desktop - recommended)
- Podman (optional Docker alternative)
```

#### iOS/macOS Development

```bash
- Xcode (from App Store - required for iOS)
- Xcode Command Line Tools
- CocoaPods (if using native iOS)
- SwiftLint (code quality)
- SF Symbols App (Apple's icon library)
```

#### API Development & Testing

```bash
- Bruno (open-source Postman alternative)
- Insomnia (API client)
- HTTPie (CLI tool)
- ngrok (local tunneling for testing)
```

#### Database Tools

```bash
- TablePlus (beautiful DB GUI - free tier available)
- Beekeeper Studio (open-source alternative)
- pgAdmin (PostgreSQL specific)
- Redis Insight (Redis GUI)
```

#### Terminal Enhancements

```bash
- iTerm2 (better terminal)
- oh-my-zsh (already using zsh)
- powerlevel10k or starship (better prompt)
- fzf (fuzzy finder)
- bat (better cat)
- eza (better ls)
- zoxide (smarter cd)
- tmux (terminal multiplexer)
```

#### Productivity Tools

```bash
- Rectangle (window management - free)
- Raycast (better Spotlight - free)
- AltTab (Windows-like alt-tab)
- Fig (terminal autocomplete)
```

---

### NAS Configuration - Ugreen DXP4800 Plus

#### Self-Hosted Services (Docker on NAS)

```yaml
Development Infrastructure:
  - Portainer (Docker management UI)
  - Gitea or GitLab CE (self-hosted Git)
  - Jenkins or Drone CI (CI/CD)
  - Nginx Proxy Manager (reverse proxy with SSL)
  - Uptime Kuma (monitoring)

Databases:
  - PostgreSQL (production-like DB)
  - MySQL/MariaDB (if needed)
  - Redis (caching layer)
  - MongoDB (if needed for projects)

Development Tools:
  - Code-server (VS Code in browser - backup dev environment)
  - n8n (workflow automation)
  - Grafana + Prometheus (monitoring/metrics)
  - Plausible Analytics (privacy-friendly analytics)

File Management:
  - Syncthing (cross-device sync)
  - Nextcloud (cloud storage alternative)
  - Duplicati (automated backups)

Media/Personal:
  - Plex or Jellyfin (media server)
  - PhotoPrism (photo management)
  - Paperless-ngx (document management)
```

#### NAS Network Setup

```
- Static IP address for NAS
- Port forwarding (if accessing remotely)
- Tailscale or WireGuard VPN (secure remote access - recommended)
- DNS configuration (local development domains)
- SSL certificates (Let's Encrypt via Nginx Proxy Manager)
```

---

### PC Configuration - Development Powerhouse

#### Recommended OS Setup

**Option 1: Dual Boot (Recommended)**

- Windows 11 (gaming)
- Ubuntu/Fedora/Pop!\_OS (Linux development)

**Option 2: Windows + WSL2**

- Windows 11 with WSL2 (Ubuntu)
- Docker Desktop for Windows

#### Use Cases for PC

```
Heavy Workloads:
- Docker development with many containers
- Large database operations
- Video encoding/processing
- AI/ML model training (RTX 4060 has CUDA)
- Building large projects (32GB RAM advantage)
- Linux-specific development
- Running virtual machines

Game Development:
- Godot with 3D projects
- Unity (if you expand)
- Unreal Engine
```

#### Software for PC

```bash
# If using Linux
- VS Code
- Docker
- All development tools (same as Mac)
- CUDA toolkit (for GPU development)
- OBS Studio (streaming/recording)

# If using Windows + WSL2
- Windows Terminal
- VS Code with Remote WSL extension
- Docker Desktop
- WSL2 Ubuntu
- PowerShell 7
- Windows Package Manager (winget)
```

---

## Network Architecture Recommendation

```
┌─────────────────────────────────────────────────────┐
│                   Internet                          │
└──────────────────────┬──────────────────────────────┘
                       │
                ┌──────▼──────┐
                │   Router    │
                │   (WiFi)    │
                └──────┬──────┘
                       │
        ───────────────┴───────────────
        │              │              │
  ┌─────▼─────┐  ┌────▼────┐   ┌────▼────┐
  │  MacBook  │  │   PC    │   │   NAS   │
  │  Air M2   │  │ (Ryzen) │   │ DXP4800 │
  │ (Primary) │  │ (Heavy) │   │ (Server)│
  └───────────┘  └─────────┘   └─────────┘
                                     │
                           ┌─────────┴─────────┐
                           │  Self-Hosted Apps │
                           │  - Git Server     │
                           │  - Databases      │
                           │  - CI/CD          │
                           │  - Web Apps       │
                           └───────────────────┘
```

---

## Memory & Performance Optimization

### MacBook Air (8GB RAM) - Optimization Tips

```
⚠️ With 8GB RAM, you'll need to be strategic:

1. Use NAS for heavy services (databases, Redis, etc.)
2. Don't run Docker containers locally when possible
3. Close unused apps aggressively
4. Use swap optimization
5. Consider remote development to PC or NAS
6. VS Code Remote Development to offload work
```

### Recommended Workflow

```
MacBook Air (8GB):
✅ Primary coding machine
✅ Light testing (single container at most)
✅ Git operations
✅ iOS development (Xcode)
✅ Web frontend development
✅ Terminal work
❌ Multiple Docker containers
❌ Heavy database operations
❌ Large builds

Gaming PC (32GB):
✅ Heavy Docker development
✅ Database development
✅ Large project builds
✅ AI/ML experiments
✅ 3D game development (Godot)
✅ Video processing
✅ Running multiple VMs
✅ Linux development environment

NAS:
✅ Production-like services
✅ Databases (PostgreSQL, Redis, etc.)
✅ Git repositories
✅ CI/CD pipelines
✅ Web app hosting
✅ File storage & backups
✅ Development environment backup
```

---

## Budget-Friendly Recommendations

### Must Have (Free/Open Source)

- ✅ VS Code + Extensions
- ✅ Homebrew
- ✅ Git + GitHub
- ✅ Docker/Orbstack
- ✅ Xcode
- ✅ PostgreSQL
- ✅ Node.js, Python
- ✅ Rectangle (window manager)
- ✅ Bruno or Insomnia (API testing)

### Nice to Have (Affordable)

- TablePlus (DB GUI) - ~$60 one-time
- Raycast Pro - $8/month (optional, free tier is great)
- Tailscale - Free for personal use
- Vercel/Netlify - Free tiers for hosting

### Skip / Use Alternatives

- ❌ Docker Desktop → Use Orbstack (better, lighter)
- ❌ Postman paid → Use Bruno or Thunder Client
- ❌ Paid cloud hosting → Self-host on NAS

---

## Setup Priority Order

### Phase 1: Core Development (Week 1)

```bash
1. Install Homebrew
2. Install Node.js, Python
3. Configure Git + GitHub CLI
4. Install essential VS Code extensions
5. Set up zsh enhancements (oh-my-zsh, starship)
6. Install Docker/Orbstack
```

### Phase 2: iOS/macOS Development (Week 1-2)

```bash
1. Install Xcode from App Store
2. Install Xcode Command Line Tools
3. Install Swift extensions for VS Code
4. Set up iOS simulator
5. Configure code signing certificates
```

### Phase 3: NAS Infrastructure (Week 2-3)

```bash
1. Configure static IP for NAS
2. Install Portainer on NAS
3. Set up Nginx Proxy Manager
4. Deploy PostgreSQL container
5. Deploy Redis container
6. Set up Gitea (self-hosted Git)
7. Configure Tailscale VPN
8. Set up backup automation
```

### Phase 4: PC Development Environment (Week 3-4)

```bash
1. Install Ubuntu or set up WSL2
2. Install VS Code + extensions
3. Install Docker
4. Configure development tools
5. Set up remote development from Mac
```

### Phase 5: Advanced Features (Ongoing)

```bash
1. CI/CD pipeline setup
2. Monitoring and logging
3. Advanced networking
4. Custom domains for local services
5. Automated deployment scripts
```

---

## Estimated Costs

### Hardware

- ✅ MacBook Air M2 - Already owned
- ✅ Gaming PC - Already owned (can repurpose for dev)
- ✅ NAS DXP4800 Plus - Already owned

### Software (One-Time)

- TablePlus License: ~$60
- Total: ~$60

### Software (Subscription) - Optional

- GitHub Copilot: Included with VS Code
- Raycast Pro: $8/month (optional)
- iCloud+ 200GB: $3/month (for backups)
- Total Monthly: $3-11

### Services (Mostly Free)

- GitHub: Free
- Vercel/Netlify: Free tier
- Tailscale: Free for personal
- Let's Encrypt: Free

**Total Startup Cost: ~$60 + optional subscriptions**

---

## Next Steps

1. [ ] Run hardware audit script to verify installed software
2. [ ] Create installation script for all recommended tools
3. [ ] Configure NAS with Docker and essential services
4. [ ] Set up development workflow between Mac, PC, and NAS
5. [ ] Create project templates for common use cases
6. [ ] Document backup and deployment procedures
7. [ ] Set up remote development configuration

---

## Questions to Consider

1. **What web frameworks are you most interested in?** (React, Vue, Svelte, Next.js?)
2. **Backend preference?** (Node.js, Python, Go, Rust?)
3. **iOS apps: Native Swift or React Native?**
4. **Database preference?** (PostgreSQL, MySQL, MongoDB?)
5. **Remote access needed?** (Access NAS/projects from outside home?)
6. **What types of games in Godot?** (2D, 3D, determines PC usage)
7. **How often will you use the PC?** (Determines if dual-boot worth it)

---

**Status:** Ready to proceed with detailed setup scripts and configurations
