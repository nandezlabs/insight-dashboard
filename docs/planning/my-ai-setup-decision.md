# My AI Server Setup - Final Decision

> **Decision Date:** December 9, 2025
> **Strategy:** Single Mac Mini now, expand to cluster in 6-12 months

---

## 🎯 **Final Decision**

### **Phase 1: Now - Single Mac Mini M4 Pro ($2,399)**

**Order Configuration:**

- **Mac Mini M4 Pro**
  - Chip: M4 Pro (14-core CPU, 20-core GPU)
  - RAM: 48GB unified memory
  - Storage: 1TB SSD
  - Network: 10 Gigabit Ethernet (+$100)
  - Price: **$2,399**

**Immediate Benefits:**

- ✅ Frees PC 100% for gaming
- ✅ Good AI performance (25-30 tok/s for 7B models)
- ✅ Handles occasional 3D Godot dev (48GB RAM)
- ✅ Low power cost ($39/year)
- ✅ macOS consistency with dev environment
- ✅ Easy setup & minimal maintenance

---

### **Phase 2: 6-12 Months - Add Second Node for Cluster**

**When to Expand:**

- AI workload grows (multiple concurrent models needed)
- Want zero-downtime updates
- Need redundancy for 24/7 uptime
- Budget available (~$2,400)

**Add:**

- 1x Mac Mini M4 Pro (same config) - $2,399
- 1x QNAP QSW-M1208-8C 10Gb switch - $400
- Cables & accessories - $100
- **Total Phase 2 cost:** ~$2,900

**Cluster Benefits:**

- ✅ 99.9% uptime (redundancy)
- ✅ 40-60 tok/s (distributed load)
- ✅ Multi-model support (different models on each node)
- ✅ Zero-downtime updates
- ✅ Scalable (add 3rd/4th node later)

---

## 📊 **Performance Overview**

### **Single Mac Mini M4 Pro Performance**

| Workload                     | Performance       | Notes                         |
| ---------------------------- | ----------------- | ----------------------------- |
| **LLaMA 7B**                 | 25-30 tok/s       | Excellent for coding, chat    |
| **LLaMA 13B**                | 15-20 tok/s       | Good for complex tasks        |
| **LLaMA 30B**                | 6-10 tok/s        | Usable for advanced reasoning |
| **LLaMA 70B**                | N/A (OOM)         | Requires cluster (2+ nodes)   |
| **Stable Diffusion 512x512** | 15-20 sec/image   | Slower than CUDA, but works   |
| **SDXL 1024x1024**           | 30-45 sec/image   | Acceptable for occasional use |
| **3D Godot Viewport**        | Smooth (48GB RAM) | Good for occasional 3D dev    |
| **Power Consumption**        | 8W idle, 30W load | ~$39/year @ $0.15/kWh         |

### **2-Node Cluster Performance (Future)**

| Workload              | Performance             | Improvement          |
| --------------------- | ----------------------- | -------------------- |
| **LLaMA 7B**          | 40-60 tok/s             | +100% (distributed)  |
| **LLaMA 13B**         | 25-40 tok/s             | +100%                |
| **LLaMA 30B**         | 12-20 tok/s             | +100%                |
| **LLaMA 70B**         | 8-15 tok/s              | ✅ Now possible      |
| **Multi-Model**       | 2 models simultaneously | ✅ Node #1 + Node #2 |
| **Uptime**            | 99.9% (redundant)       | vs 95% single node   |
| **Power Consumption** | 16W idle, 60W load      | ~$79/year            |

---

## 🛠️ **Setup & Configuration Reference**

### **Phase 1: Single Node Setup**

#### **Initial Setup (Day 1)**

```bash
# 1. Unbox and connect Mac Mini
# 2. macOS setup (15 min)
# 3. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 4. Install Ollama for AI
brew install ollama

# 5. Start Ollama service
ollama serve &

# 6. Download models (runs in background, 2-6 hours)
ollama pull llama3.1:7b
ollama pull codellama:13b
ollama pull mistral:7b

# 7. Test
ollama run llama3.1:7b "Write a hello world in Python"
```

#### **Optional: Install Docker for containers**

```bash
# Download Docker Desktop for Mac from docker.com
# Or use Homebrew Cask
brew install --cask docker
```

#### **Optional: Install MLX for Apple Silicon optimization**

```bash
# MLX is Apple's ML framework optimized for M-series chips
pip install mlx mlx-lm
```

#### **VS Code Integration**

```bash
# Install Continue.dev extension for inline AI
# Or install GitHub Copilot extension
# Both can connect to local Ollama instance
```

---

### **Phase 2: Cluster Setup (Future Reference)**

#### **Cluster Software Stack**

```bash
# Ray Cluster (Distributed Python/ML framework)
brew install python@3.11
pip3 install ray[default] ray[serve]

# On Node #1 (Head):
ray start --head --port=6379 --dashboard-host=0.0.0.0

# On Node #2 (Worker):
ray start --address='<NODE1_IP>:6379'

# Load Balancer (nginx)
brew install nginx
# Configure upstream servers for round-robin

# Monitoring
brew install prometheus grafana
```

#### **Model Distribution Strategy**

```bash
# Option A: NAS shared storage
# - Store models on NAS (already have Ugreen DXP4800)
# - Both nodes read from NFS share
# - Pros: Single source of truth
# - Cons: Network overhead

# Option B: Local replication
# - Duplicate models on both nodes (faster)
# - Sync with rsync or custom script
# - Pros: Fastest access
# - Cons: More storage used

# Option C: Hybrid (Recommended)
# - Hot models (7B, 13B) stored locally on both
# - Cold models (30B, 70B) on NAS
# - Best balance of speed and storage
```

---

## 💰 **Cost Summary**

### **Phase 1: Now**

| Item                              | Cost       |
| --------------------------------- | ---------- |
| Mac Mini M4 Pro (48GB, 1TB, 10Gb) | $2,399     |
| **Total**                         | **$2,399** |

### **Phase 2: 6-12 Months**

| Item                             | Cost       |
| -------------------------------- | ---------- |
| Mac Mini M4 Pro #2 (same config) | $2,399     |
| QNAP QSW-M1208-8C 10Gb switch    | $400       |
| Cat6a cables (x3)                | $30        |
| Dual stand/rack                  | $70        |
| **Total Phase 2**                | **$2,899** |

### **Total Investment**

| Timeline         | Total Spent | Capability                      |
| ---------------- | ----------- | ------------------------------- |
| **Now**          | $2,399      | Single node AI, frees PC gaming |
| **After 6-12mo** | $5,298      | 2-node cluster, HA, redundancy  |

### **3-Year TCO**

| Phase              | Initial | Power (3yr) | Maintenance | Total  |
| ------------------ | ------- | ----------- | ----------- | ------ |
| **Single Node**    | $2,399  | $117        | $225        | $2,741 |
| **2-Node Cluster** | $5,298  | $237        | $450        | $5,985 |

---

## 🔄 **Migration Path: Single → Cluster**

### **When Ready to Add Node #2**

```bash
# Step 1: Order 2nd Mac Mini (same config)
# Step 2: Order 10Gb switch
# Step 3: Setup Node #2 (same as Node #1)

# Step 4: Install cluster software on both nodes
# Ray, load balancer, monitoring

# Step 5: Migrate AI services to cluster
# - Stop Ollama on Node #1
# - Start Ray cluster on both
# - Configure load balancer
# - Test failover

# Step 6: Transition workloads
# Week 1: Canary (10% traffic to cluster)
# Week 2: Ramp up (50% traffic)
# Week 3: Full migration (100% cluster)
# Week 4: Decommission old single-node setup

# Zero downtime: Old setup runs while cluster tested
```

### **Workload Distribution (Future Cluster)**

**Configuration A: HA AI Focus**

- Both nodes serve AI (load balanced 50/50)
- Either can handle 3D dev when needed
- Failover automatic

**Configuration B: Dedicated Roles**

- Node #1: AI workloads (100%)
- Node #2: 3D Godot dev + AI backup
- When not doing 3D, both serve AI

**Configuration C: Multi-Model**

- Node #1: LLaMA models (coding, reasoning)
- Node #2: Mistral/SD models (chat, images)
- Specialized roles, both available 24/7

---

## 📝 **Next Steps**

### **Immediate (This Week)**

- [x] Research complete
- [x] Decision made: Mac Mini M4 Pro 48GB
- [ ] Order Mac Mini from Apple Store
- [ ] Wait for delivery (3-7 days)
- [ ] Setup and configure (Day 1)
- [ ] Download AI models (overnight)
- [ ] Test AI workflows (Day 2)
- [ ] Integrate with VS Code (Day 2)

### **Short-term (1-3 Months)**

- [ ] Monitor AI usage patterns
- [ ] Track model performance
- [ ] Evaluate if single node sufficient
- [ ] Test 3D Godot workflows on Mac Mini

### **Medium-term (6-12 Months)**

- [ ] Decide if cluster needed (based on usage)
- [ ] If yes: Order 2nd Mac Mini + switch
- [ ] Setup cluster configuration
- [ ] Migrate to HA setup
- [ ] Learn Ray/K8s for cluster management

### **Long-term (12-18 Months)**

- [ ] Evaluate main Mac upgrade (Mac Studio/MacBook Pro M4 Pro)
- [ ] Decide cluster vs single powerful Mac
- [ ] If Mac Studio sufficient: Sell one Mac Mini
- [ ] If cluster valuable: Keep both, add 3rd node

---

## 🔗 **Reference Links**

### **Hardware**

- Mac Mini M4 Pro: https://www.apple.com/shop/buy-mac/mac-mini
- QNAP 10Gb Switch: https://www.qnap.com/en/product/qsw-m1208-8c

### **Software**

- Ollama (AI models): https://ollama.ai
- Ray Cluster: https://docs.ray.io/en/latest/cluster/getting-started.html
- MLX (Apple Silicon ML): https://github.com/ml-explore/mlx
- Continue.dev (VS Code AI): https://continue.dev
- Docker Desktop: https://www.docker.com/products/docker-desktop

### **Guides**

- Ollama + Mac Mini: https://ollama.ai/blog/mac-mini-m4
- Ray on macOS: https://docs.ray.io/en/latest/ray-core/starting-ray.html
- nginx Load Balancer: https://nginx.org/en/docs/http/load_balancing.html

---

## 🎮 **PC Gaming Freedom**

**Result of This Setup:**

- ✅ PC dedicated 100% to gaming (no AI services)
- ✅ No dynamic resource limiting needed
- ✅ No service management on PC
- ✅ Steam Big Picture mode auto-launch (planned)
- ✅ Pure gaming experience

**Mac Mini Handles:**

- AI inference (Ollama, LLM models)
- Occasional 3D Godot development
- VS Code AI integrations
- Background services

**Separation Achieved:** ✅ Complete

---

**Status:** Phase 1 ready to execute. Order Mac Mini M4 Pro when ready. Cluster expansion planned for 6-12 months based on actual usage.
