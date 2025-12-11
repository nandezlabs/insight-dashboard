# Mac Mini Cluster - Future AI Hub Strategy

**Created:** December 9, 2025  
**Purpose:** Long-term strategy to move AI workloads to dedicated Mac Mini cluster, freeing PC for gaming only

---

## 📋 Executive Summary

**Current State:**

- PC: Gaming + AI workloads (shared resources, dynamic limiting)
- Mac: Primary development (8GB, limited)
- NAS: Storage, databases, services

**Future State:**

- PC: Gaming ONLY (100% dedicated, no compromises)
- Mac Mini Cluster: AI Hub (dedicated AI inference, always-on)
- MacBook/Mac Studio: Primary development (upgraded, powerful)
- NAS: Storage, databases, services (unchanged)

**Timeline:** 1-2 years (when ready to invest ~$3,000-6,000)

---

## 🎯 Why Mac Mini Cluster for AI?

### **Advantages Over PC AI**

```
Mac Mini Benefits:
✅ Always-on (low power, designed for 24/7)
✅ Silent operation (fanless M-series)
✅ Native macOS (consistent with dev environment)
✅ Scalable (add more Minis as needed)
✅ Unified architecture (Apple Silicon optimized)
✅ PC completely free for gaming
✅ Better ML performance (Apple Neural Engine)
✅ Lower power consumption than PC
✅ Clusterable for larger models

PC Benefits (Current):
✅ CUDA support (NVIDIA RTX 4060)
✅ Already owned (no cost)
✅ Powerful GPU for Stable Diffusion
✅ Large RAM (32GB)

Trade-offs:
⚠️ Mac Mini lacks CUDA (no NVIDIA)
⚠️ Apple Silicon MLX instead (different ecosystem)
⚠️ Stable Diffusion slower on Mac (but works)
⚠️ Initial cost: $1,500-2,000 per Mini
```

---

## 💻 Mac Mini Cluster Architectures

### **Option 1: Single Mac Mini M4 Pro (Entry Point)**

**Hardware:**

```
Mac Mini M4 Pro (2024/2025):
├── Chip: M4 Pro (14-core CPU, 20-core GPU)
├── RAM: 48GB unified memory (minimum for AI)
├── Storage: 512GB SSD (models on NAS)
├── Neural Engine: 16-core (AI acceleration)
├── Ports: Thunderbolt 4, 10Gb Ethernet
├── Power: ~15-30W typical, 50W max
└── Price: ~$2,000-2,500

Capabilities:
✓ LLaMA 7B:    20-30 tok/sec (good)
✓ LLaMA 13B:   12-18 tok/sec (acceptable)
✓ LLaMA 30B:   4-8 tok/sec (slow but works)
✓ Mistral 7B:  25-35 tok/sec (excellent)
✓ SD via MLX:  15-30 sec/image (slower than CUDA)
✓ 24/7 uptime
```

**When to Choose:**

- Budget: ~$2,500
- Basic AI needs (7B-13B models)
- Testing cluster concept
- Don't need cutting-edge performance

---

### **Option 2: Dual Mac Mini M4 Pro Cluster**

**Hardware:**

```
2x Mac Mini M4 Pro:
├── Each: M4 Pro, 48GB RAM, 512GB
├── Connected via 10Gb Ethernet
├── Ray cluster for distributed inference
├── Total: 96GB unified memory
├── Combined Neural Engine: 32 cores
└── Price: ~$4,000-5,000

Capabilities:
✓ LLaMA 7B:    40-60 tok/sec (distributed)
✓ LLaMA 13B:   25-40 tok/sec (excellent)
✓ LLaMA 30B:   12-20 tok/sec (distributed)
✓ LLaMA 70B:   6-12 tok/sec (possible!)
✓ Multiple models simultaneously
✓ Fallback redundancy (one fails, other continues)
✓ Load balancing
```

**Cluster Software:**

```
Ray (distributed computing):
├── Automatically distributes workload
├── Load balances requests
├── Fault tolerance
└── Works with MLX/Ollama

Or

Custom load balancer:
├── Round-robin requests
├── Model sharding
├── Simple nginx proxy
```

**When to Choose:**

- Budget: ~$5,000
- Serious AI workloads (30B+ models)
- Need redundancy
- Multiple concurrent users
- Future-proof investment

---

### **Option 3: Mac Studio M2/M4 Ultra (Performance Beast)**

**Hardware:**

```
Mac Studio M4 Ultra (when available):
├── Chip: M4 Ultra (up to 32-core CPU, 80-core GPU)
├── RAM: 128GB-192GB unified memory
├── Storage: 1TB SSD
├── Neural Engine: 32-core
├── Power: ~60W typical, 100W max
└── Price: ~$5,000-7,000

Capabilities:
✓ LLaMA 7B:    60-80 tok/sec (blazing fast)
✓ LLaMA 13B:   40-60 tok/sec (excellent)
✓ LLaMA 30B:   25-40 tok/sec (great)
✓ LLaMA 70B:   12-20 tok/sec (usable)
✓ LLaMA 180B:  6-10 tok/sec (barely possible)
✓ Multiple concurrent models
✓ Stable Diffusion: 10-20 sec/image
✓ Single powerful node (no cluster complexity)
```

**When to Choose:**

- Budget: ~$6,000-8,000
- Maximum performance needed
- Prefer simplicity over clustering
- Large models (70B+) regularly
- Professional/production use

---

## 📊 Performance Comparison

### **AI Inference Speed (tokens/sec)**

| Model             | Current PC (RTX 4060) | Mac Mini M4 Pro | 2x Mini Cluster | Mac Studio Ultra |
| ----------------- | --------------------- | --------------- | --------------- | ---------------- |
| **LLaMA 7B**      | 40-50                 | 25-30           | 40-60           | 60-80            |
| **LLaMA 13B**     | 25-35                 | 15-20           | 25-40           | 40-60            |
| **LLaMA 30B**     | 12-18                 | 6-10            | 12-20           | 25-40            |
| **LLaMA 70B**     | 5-8 (swap)            | N/A (OOM)       | 8-15            | 15-25            |
| **Mistral 7B**    | 45-55                 | 30-40           | 50-70           | 70-90            |
| **CodeLlama 13B** | 30-40                 | 18-25           | 30-45           | 45-65            |

### **Stable Diffusion (sec/image)**

| Resolution | PC (RTX 4060 CUDA) | Mac Mini M4 Pro | Mac Studio Ultra |
| ---------- | ------------------ | --------------- | ---------------- |
| 512x512    | 3-5 sec            | 15-20 sec       | 8-12 sec         |
| 768x768    | 8-12 sec           | 30-45 sec       | 15-25 sec        |
| 1024x1024  | 15-25 sec          | 60-90 sec       | 30-50 sec        |

**Verdict:**

- PC CUDA is ~3-5x faster for Stable Diffusion
- Mac Mini competitive for text generation (LLM)
- Mac Studio approaches PC performance for LLM
- Cluster beats single PC for large models

---

## 💰 Cost Analysis

### **Initial Investment**

| Option                     | Hardware   | Networking | Total      |
| -------------------------- | ---------- | ---------- | ---------- |
| **Keep PC AI (Current)**   | $0 (owned) | $0         | **$0**     |
| **Single Mac Mini M4 Pro** | $2,200     | $100       | **$2,300** |
| **2x Mac Mini Cluster**    | $4,400     | $400       | **$4,800** |
| **Mac Studio Ultra**       | $6,000     | $100       | **$6,100** |

### **Operating Costs (Annual)**

| Option              | Power (kWh/mo) | Cost/mo (@$0.15/kWh) | Cost/year |
| ------------------- | -------------- | -------------------- | --------- |
| **PC AI (24/7)**    | 130 kWh        | $19.50               | **$234**  |
| **Single Mac Mini** | 25 kWh         | $3.75                | **$45**   |
| **2x Mac Mini**     | 50 kWh         | $7.50                | **$90**   |
| **Mac Studio**      | 45 kWh         | $6.75                | **$81**   |

**Power Savings:**

- Mac Mini vs PC: **$189/year saved**
- 2x Mini vs PC: **$144/year saved**
- Mac Studio vs PC: **$153/year saved**

**Payback Period (Power Savings Only):**

- Single Mini: 12 years (not worth it for power alone)
- 2x Mini: 33 years (definitely not about power)
- Mac Studio: 40 years (clearly not the reason)

**Real Value:** Freeing PC for gaming + better AI experience + macOS consistency

---

## ⏱️ Downtime & Migration Analysis

### **Migration Phases**

#### **Phase 1: Planning (Week 1-2)**

```
Tasks:
□ Purchase Mac Mini(s)
□ Configure network (10Gb Ethernet recommended)
□ Install macOS
□ Set up Homebrew, Docker
□ Install Ollama, MLX
□ Download AI models to NAS
□ Test basic inference

Downtime: 0 hours (PC AI still running)
```

#### **Phase 2: Parallel Testing (Week 3-4)**

```
Tasks:
□ Run Mac Mini AI in parallel with PC
□ Test performance with real workloads
□ Configure load balancing (if cluster)
□ Set up monitoring (Grafana)
□ Train team/self on Mac AI tools
□ Document differences from CUDA

Downtime: 0 hours (both systems running)
```

#### **Phase 3: Gradual Migration (Week 5-6)**

```
Tasks:
□ Route 25% of AI requests to Mac Mini
□ Monitor performance and issues
□ Increase to 50%, then 75%, then 100%
□ Keep PC AI as fallback
□ Test failure scenarios

Downtime: 0 hours (gradual shift)
```

#### **Phase 4: Full Cutover (Week 7)**

```
Tasks:
□ Route 100% AI traffic to Mac Mini cluster
□ Keep PC AI services stopped but configured
□ Monitor for 1 week
□ Decommission PC AI if stable
□ Optimize Mac Mini config

Downtime: ~30 minutes (DNS/routing change)
```

#### **Phase 5: PC Gaming Optimization (Week 8)**

```
Tasks:
□ Remove all AI services from PC
□ Uninstall Docker, Ollama
□ Clean boot configuration
□ Optimize for pure gaming
□ Install SteamOS or gaming optimizations
□ Celebrate 100% gaming performance!

Downtime: 0 hours (PC gaming unaffected)
```

**Total Migration Time:** 8 weeks (gradual, no rush)  
**Total AI Downtime:** ~30 minutes (only during cutover)  
**Risk:** Very low (parallel systems, gradual migration)

---

## 🏗️ Architecture Comparison

### **Current Architecture (PC AI)**

```
                    Internet
                        │
                    Router
                        │
        ┌───────────────┼───────────────┐
        │               │               │
    ┌───▼───┐      ┌────▼────┐     ┌───▼───┐
    │  Mac  │      │   PC    │     │  NAS  │
    │  Air  │      │ Gaming  │     │DXP4800│
    │  (8GB)│      │   +AI   │     │(12TB) │
    └───┬───┘      └────┬────┘     └───┬───┘
        │               │               │
        │     ┌─────────┴──────┐        │
        │     │                 │        │
    Development   Gaming    AI Models   Databases
    (VS Code)     (Steam)   (Ollama)    (Postgres)
                           (Stable      (Git)
                            Diffusion)  (Storage)

Pros:
✓ No extra hardware cost
✓ Powerful GPU (CUDA)
✓ Already set up

Cons:
✗ Gaming competes with AI
✗ PC must be on for AI
✗ Higher power usage
✗ Not optimized for 24/7
```

---

### **Future Architecture (Mac Mini Cluster)**

```
                    Internet
                        │
                    Router (10Gb Switch)
                        │
        ┌───────────────┼───────────────────┐
        │               │                   │
    ┌───▼────┐     ┌────▼─────┐      ┌─────▼─────┐
    │MacBook │     │    PC    │      │    NAS    │
    │Pro M4  │     │  Gaming  │      │  DXP4800  │
    │(32GB)  │     │   ONLY   │      │  (12TB)   │
    └───┬────┘     └──────────┘      └─────┬─────┘
        │                                   │
        │          ┌────────────────────────┤
        │          │                        │
        │     ┌────▼─────┐          ┌──────▼──────┐
        │     │ Mac Mini │          │  Mac Mini   │
        │     │    #1    │─────────▶│     #2      │
        │     │ (AI Hub) │ 10Gb     │ (AI Hub)    │
        │     │  M4 Pro  │ Link     │   M4 Pro    │
        │     │  48GB    │          │   48GB      │
        │     └────┬─────┘          └──────┬──────┘
        │          │                       │
        └──────────┴───────────────────────┘
                   │
        ┌──────────▼──────────┐
        │   AI Services       │
        ├─────────────────────┤
        │ Ollama (all models) │
        │ Stable Diffusion    │
        │ Open WebUI          │
        │ Ray (distributed)   │
        │ Load Balancer       │
        └─────────────────────┘

Pros:
✓ PC 100% for gaming
✓ AI always available (24/7)
✓ Lower power (silent)
✓ Scalable (add more)
✓ macOS consistency
✓ Redundancy (2 nodes)
✓ Better multi-model support

Cons:
✗ Initial cost ($5K)
✗ No CUDA (slower SD)
✗ Learning curve (MLX)
✗ More devices to manage
```

---

## 🛠️ Setup Complexity

### **Single Mac Mini M4 Pro**

**Setup Steps:**

```
1. Unbox and connect (30 min)
   ├── Power, Ethernet, peripherals
   └── Initial macOS setup

2. Software installation (2 hours)
   ├── Homebrew
   ├── Ollama for Mac
   ├── Docker Desktop
   ├── MLX framework
   └── Monitoring tools

3. Model download (4-8 hours)
   ├── LLaMA models from NAS
   ├── Mistral, CodeLlama
   └── SD models (if using)

4. Configuration (1 hour)
   ├── Network settings (static IP)
   ├── Ollama API config
   ├── Open WebUI
   └── Firewall rules

5. Integration (2 hours)
   ├── Mac connection test
   ├── VS Code integration
   ├── API endpoint updates
   └── Documentation

Total Setup: 1 day (mostly waiting for downloads)
Complexity: Low (straightforward)
```

### **Dual Mac Mini Cluster**

**Setup Steps:**

```
1. Hardware setup (1 hour)
   ├── Unbox both Minis
   ├── Connect to 10Gb switch
   ├── Power and peripherals
   └── Initial macOS setup (both)

2. Software installation (3 hours)
   ├── Homebrew (both)
   ├── Docker (both)
   ├── Ray cluster framework
   ├── Ollama (both)
   └── MLX (both)

3. Cluster configuration (4 hours)
   ├── Ray head node (Mini #1)
   ├── Ray worker node (Mini #2)
   ├── Network discovery
   ├── Load balancer (nginx)
   ├── Health checks
   └── Failover setup

4. Model distribution (6 hours)
   ├── Download to shared NAS
   ├── Model sharding (70B)
   ├── Replication (7B, 13B)
   └── Test distributed inference

5. Monitoring setup (2 hours)
   ├── Grafana dashboard
   ├── Prometheus metrics
   ├── Ray dashboard
   └── Alerts

6. Integration & testing (3 hours)
   ├── Load balancing test
   ├── Failover test
   ├── Performance benchmark
   └── Client integration

Total Setup: 2-3 days
Complexity: Medium (cluster config)
```

---

## 📈 Performance Scaling

### **Workload Distribution Examples**

**Scenario 1: Single User (You)**

```
Mac Mini Cluster Utilization:
├── Mini #1: 40% avg (primary requests)
├── Mini #2: 20% avg (secondary requests)
└── Overkill? Maybe. But: redundancy + scalability

Single Mac Studio:
├── 30% avg utilization
└── More cost-effective for single user
```

**Scenario 2: Multiple Users (Team/Family)**

```
Mac Mini Cluster:
├── Mini #1: 70% avg
├── Mini #2: 70% avg
└── Perfect utilization

Single Mac Studio:
├── 85% avg
└── Near capacity, might bottleneck
```

**Recommendation:**

- You alone: Mac Studio is better value
- Future team/family use: Cluster is better
- Budget constrained: Single Mac Mini is fine

---

## 🔄 Migration Strategy (Detailed)

### **Option A: Cold Turkey (Risky)**

```
Friday Night:
1. Turn off PC AI services
2. Turn on Mac Mini AI
3. Update all client configs
4. Test
5. Hope it works Monday

Risk: High
Downtime: 2-12 hours
Cost: $0 extra
Stress: Maximum
```

### **Option B: Blue-Green Deployment (Recommended)**

```
Week 1-2: Green Environment (Current PC)
├── PC AI running (production)
├── All clients use PC
└── Stable

Week 3-4: Blue Environment Setup
├── Mac Mini AI setup (parallel)
├── Copy models from NAS
├── Test independently
└── Zero downtime

Week 5: Smoke Testing
├── Route 10% traffic to Mac Mini
├── Monitor errors
├── Fix issues
└── Increase to 25%, 50%, 75%

Week 6: Full Migration
├── 100% traffic to Mac Mini
├── PC AI on standby (green)
└── Monitor for 1 week

Week 7: Decommission
├── Turn off PC AI
├── Clean up PC
└── Celebrate!

Risk: Very Low
Downtime: ~0 hours
Cost: $0 extra
Stress: Minimal
```

### **Option C: Canary Deployment**

```
Deploy to 1% of requests → Monitor → 5% → 10% → 25% → 50% → 100%

Each step: 2-3 days of monitoring
Total time: 4-6 weeks
Risk: Lowest
Best for: Production/critical workloads
```

---

## 💡 Recommendations

### **For Your Situation:**

**Now (0-12 months):**

```
✅ Keep using PC for AI
✅ Implement dynamic resource limiting
✅ Optimize gaming experience
✅ Save money for future Mac upgrade
✅ Monitor your actual AI usage patterns
```

**When You Upgrade Main Mac (12-18 months):**

```
Decision Point:

If buying MacBook Pro 16" M4 Pro (32GB+):
→ Keep using it for AI too
→ Delay Mac Mini cluster
→ Mac Pro powerful enough for dev + light AI

If buying Mac Studio M4 Ultra:
→ Use as AI hub AND dev machine
→ Single powerful system
→ No cluster needed

If buying MacBook Air/smaller:
→ Then consider Mac Mini cluster
→ Or single Mac Mini M4 Pro
```

**When PC Truly Needed for Gaming Only (18-24 months):**

```
Best Value:
├── Single Mac Studio M4 Ultra ($6K)
│   ├── Dev machine + AI hub
│   ├── No cluster complexity
│   ├── Plenty powerful
│   └── Simple setup

Budget Option:
├── Single Mac Mini M4 Pro ($2.5K)
│   ├── Dedicated AI only
│   ├── Keep using MacBook for dev
│   └── Good enough for most AI tasks

Enthusiast/Future-Proof:
├── 2x Mac Mini M4 Pro ($5K)
    ├── Dedicated AI cluster
    ├── Scalable, redundant
    ├── Learn cluster tech
    └── Overkill but fun
```

---

## 📊 Decision Matrix

| Factor                | Keep PC AI      | Mac Mini M4 Pro | 2x Mini Cluster | Mac Studio Ultra |
| --------------------- | --------------- | --------------- | --------------- | ---------------- |
| **Cost (Initial)**    | ★★★★★ ($0)      | ★★★☆☆ ($2.5K)   | ★★☆☆☆ ($5K)     | ★☆☆☆☆ ($6K)      |
| **Gaming Freedom**    | ★★☆☆☆ (Limited) | ★★★★★ (100%)    | ★★★★★ (100%)    | ★★★★★ (100%)     |
| **AI Performance**    | ★★★★☆ (CUDA)    | ★★★☆☆ (Good)    | ★★★★☆ (Great)   | ★★★★★ (Best)     |
| **Power Efficiency**  | ★★☆☆☆ (High)    | ★★★★★ (Low)     | ★★★★☆ (Low)     | ★★★★☆ (Med)      |
| **Setup Complexity**  | ★★★★★ (Done)    | ★★★★☆ (Easy)    | ★★★☆☆ (Med)     | ★★★★☆ (Easy)     |
| **Scalability**       | ★☆☆☆☆ (None)    | ★★☆☆☆ (Low)     | ★★★★★ (High)    | ★★★☆☆ (Med)      |
| **24/7 Reliability**  | ★★☆☆☆ (PC)      | ★★★★★ (Mac)     | ★★★★★ (Mac)     | ★★★★★ (Mac)      |
| **macOS Integration** | ★★☆☆☆ (Remote)  | ★★★★★ (Native)  | ★★★★★ (Native)  | ★★★★★ (Native)   |
| **Noise Level**       | ★★☆☆☆ (Loud)    | ★★★★★ (Silent)  | ★★★★★ (Silent)  | ★★★★☆ (Quiet)    |
| **Stable Diffusion**  | ★★★★★ (CUDA)    | ★★☆☆☆ (Slow)    | ★★☆☆☆ (Slow)    | ★★★☆☆ (OK)       |

---

## 🎯 Final Recommendation

### **Phase 1: Now (Next 12 months)**

```
Action: Optimize current setup
├── Implement dynamic AI resource limiting on PC
├── Auto-launch Steam Big Picture
├── Save for future Mac upgrade
└── Total cost: $0

Benefits:
✓ Good enough gaming experience
✓ AI available (limited while gaming)
✓ Time to evaluate actual AI needs
✓ Build up budget
```

### **Phase 2: Main Mac Upgrade (12-18 months)**

```
Action: Upgrade MacBook Air → Mac Studio M4 Ultra
Cost: ~$6,000
Reason: Need more power for 3D Godot anyway

Benefits:
✓ Powerful dev machine (32GB+ RAM, great GPU)
✓ Can handle AI workloads too
✓ Reduces need for dedicated AI cluster
✓ Single powerful machine vs cluster complexity
✓ 3D game development enabled
```

### **Phase 3: If Still Need Dedicated AI (24+ months)**

```
Action: Add Mac Mini M4 Pro as dedicated AI
Cost: ~$2,500
Setup: Use Mac Studio for dev, Mac Mini for AI

Benefits:
✓ PC now 100% gaming
✓ Mac Studio 100% dev
✓ Mac Mini 100% AI (24/7)
✓ Clean separation of concerns
✓ Total investment: $8,500 over 2 years
```

---

## 📋 Summary

**TL;DR:**

1. **Now:** Keep using PC for AI with smart limiting ($0)
2. **Year 1:** Upgrade main Mac to M4 Pro/Ultra ($6K) - handles dev + AI
3. **Year 2:** If needed, add Mac Mini for dedicated AI ($2.5K)
4. **Result:** PC = gaming, Mac = everything else, NAS = storage

**Why This Approach:**

- ✅ Spreads cost over time
- ✅ No rush, test what you actually need
- ✅ Main Mac upgrade you need anyway (for 3D dev)
- ✅ Can add AI cluster later if needed
- ✅ Or maybe Mac Studio enough for everything

**Total Investment:** $6K-8.5K over 2 years (vs. $5K now for cluster you might not need)

---

**Status:** Strategy documented. Ready to execute Phase 1 optimizations now, plan for Phase 2 upgrade in 2026.
