# Development Tools & Scripts

Automation scripts for Mac setup, NAS deployment, and project management.

---

## 📂 Directory Structure

### Setup (`./setup/`)

- **`setup-mac-dev.sh`** - Complete Mac developer environment setup

  - Installs: Homebrew, Git, Node.js, Python, VS Code, Docker
  - Configures shell aliases
  - Runs VS Code backup restoration

- **`setup-nas.sh`** - NAS server configuration
  - Docker environment setup
  - NAS connection configuration
  - Service deployment preparation

### Deployment (`./deployment/`)

- **`nas-deploy.sh`** - Deploy projects to NAS

  - Automated Docker build & deployment
  - Environment configuration
  - Service health checks

- **`nas-workflow.sh`** - Complete NAS workflow automation

  - End-to-end deployment pipeline
  - Multi-environment support

- **`migrate-cloud.sh`** - Cloud migration utilities
  - iCloud & Google Drive sync
  - Backup automation

### Project Management (`./project-management/`)

- **`create-project.sh`** - New project scaffolding

  - Creates standardized project structure
  - Initializes Git repository
  - Sets up development environment

- **`create-godot-project.sh`** - Godot game project creator

  - Creates 2D or 3D Godot projects
  - Standard directory structure with organized folders
  - VS Code workspace configuration
  - Git repository with proper .gitignore
  - Starter scenes and project files

- **`manage-vscode.sh`** - VS Code configuration management
  - Backup/restore extensions
  - Settings synchronization

---

## 🚀 Quick Start

### Mac Setup (Fresh Install or Upgrade)

```bash
bash ~/Developer/tools/setup/setup-mac-dev.sh
```

### Create New Project

```bash
# General project
bash ~/Developer/tools/project-management/create-project.sh

# Godot game project (2D)
bash ~/Developer/tools/project-management/create-godot-project.sh --name "My Game" --type 2d

# Godot game project (3D)
bash ~/Developer/tools/project-management/create-godot-project.sh --name "3D Adventure" --type 3d
```

### Deploy to NAS

```bash
bash ~/Developer/tools/deployment/nas-deploy.sh <project-name> <environment>
```

---

## 📚 Documentation

Full guides available in `~/Developer/docs/setup/`:

- **MAC-SETUP-GUIDE.md** - Comprehensive Mac setup instructions
- **NAS-SETUP-GUIDE.md** - NAS configuration guide

---

**Last Updated**: December 9, 2025
