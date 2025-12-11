# UGREEN DXP4800 Plus - First Time Setup

> **NAS:** UGREEN NASync DXP4800 Plus  
> **Mac:** MacBook Air M2  
> **Method:** Direct Ethernet connection (easiest)  
> **Date:** December 9, 2025

---

## 🎯 What We're Setting Up

**Your NAS will:**

- Store all your development projects (sync with Mac)
- Run Docker services (databases, storage apps)
- Handle backups automatically
- Be accessible from Mac, PC, phone

**Note:** NAS is for storage + databases. Mac mini M4 Pro will handle AI workloads.

---

## ✅ Prerequisites

- [x] Mac prep completed (SSH key, tools, configs ready)
- [ ] NAS has finished booting (lights stopped blinking)
- [ ] Ethernet cable ready
- [ ] Mac has Ethernet port or USB-C adapter
- [ ] Fresh reset complete (you just did this)

**Your SSH public key (save this):**

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzSKsnurbIFZwPdj5dZZYo1nRVAPNC3v1RrJcMi190/ nandez@mac
```

---

# 🚀 SETUP STEPS

## **STEP 1: Connect NAS Directly to Mac**

**Physical connection:**

1. Plug Ethernet cable into NAS (any LAN port)
2. Plug other end into Mac (Ethernet port or USB-C adapter)
3. Wait 30 seconds for Mac to recognize connection

**✅ Expected result:** Network icon shows Ethernet connected

---

## **STEP 2: Find NAS IP Address**

**On Mac, open Terminal and run:**

```bash
arp -a | grep -i "ugreen\|ugos"
```

**Alternative method if that doesn't work:**

```bash
# Scan for devices on direct connection
ifconfig | grep "inet " | grep "169.254\|192.168"
```

**Most likely IPs for direct connection:**

- `169.254.x.x` (auto-assigned link-local)
- `192.168.137.x` (if Mac sharing enabled)
- `192.168.0.x` (NAS default)

**Write down the IP:** ********\_\_\_********

---

## **STEP 3: Access NAS Web Interface**

**In Safari or Chrome, go to:**

```
http://NAS_IP_HERE
```

**Common ports to try if that doesn't work:**

- `http://NAS_IP:80`
- `http://NAS_IP:5000`
- `http://NAS_IP:9999`

**✅ Expected result:** UGREEN NASync setup wizard appears

**If nothing loads:**

```bash
# Ping the NAS to verify connection
ping 192.168.0.1
# Try common default IPs
# 192.168.0.1, 192.168.1.1, 169.254.x.x
```

---

## **STEP 4: Run Initial Setup Wizard**

**Follow the web wizard:**

### **4a. Admin Account**

- **Username:** `nandez` (or your preference)
- **Password:** Strong password (save in keychain)
- **Email:** Your email (for notifications)

### **4b. Storage Pool Setup**

**Configuration:** RAID 5 (recommended for 4-bay)

**Why RAID 5:**

- Uses 3 drives for data, 1 for redundancy
- Can lose 1 drive without data loss
- Good balance of capacity + safety
- ~12TB usable from 4x 4TB drives

**In the wizard:**

1. Select RAID 5
2. Select all 4 drives
3. Click "Create Storage Pool"
4. **⏳ This takes 4-8 hours** (you can continue setup while building)

### **4c. Network Settings (CRITICAL)**

**Set Static IP (important!):**

Since you're on direct connection now, we'll configure for your router:

- **IP Address:** `192.168.1.177` (or pick unused IP on your network)
- **Subnet:** `255.255.255.0`
- **Gateway:** `192.168.1.1` (your router IP)
- **DNS:** `8.8.8.8` (Google DNS)

**Why static IP?** So NAS always has same address (important for Docker, dev tools, etc.)

---

## **STEP 5: Enable SSH Access**

**In NAS web interface:**

1. Go to **Control Panel** → **Terminal & SNMP**
2. Check **Enable SSH service**
3. Port: **22** (default)
4. Click **Apply**

**✅ Expected result:** SSH enabled

---

## **STEP 6: Connect NAS to Router**

**Now that initial setup is done:**

1. **Unplug Ethernet from Mac**
2. **Plug Ethernet into your router** (any LAN port)
3. Wait 1 minute for NAS to get network connection

**Verify connection from Mac:**

```bash
ping 192.168.1.177
```

**✅ Expected result:** Replies from NAS

**Access web interface from new IP:**

```
http://192.168.1.177
```

---

## **STEP 7: Test SSH Connection**

**On Mac Terminal:**

```bash
ssh nandez@192.168.1.177
```

**First connection will ask:**

```
Are you sure you want to continue? (yes/no)
```

Type `yes` and press Enter

**Enter your NAS password**

**✅ Expected result:** You're logged into NAS terminal

**Test Docker is available:**

```bash
docker --version
docker ps
```

**Exit SSH:**

```bash
exit
```

---

## **STEP 8: Create Shared Folders**

**Back in NAS web interface:**

Go to **Control Panel** → **Shared Folder** → **Create**

**Create these folders:**

1. **development**

   - Description: "Dev projects and code"
   - Enable: SMB, NFS
   - Permissions: Read/Write for your user

2. **backups**

   - Description: "Mac Time Machine + manual backups"
   - Enable: SMB, AFP
   - Permissions: Read/Write for your user

3. **cloud**

   - Description: "Personal files (iCloud replacement)"
   - Enable: SMB
   - Permissions: Read/Write for your user

4. **docker-data**
   - Description: "Docker volumes and configs"
   - Enable: NFS only
   - Permissions: Read/Write for your user

**✅ Expected result:** 4 shared folders created

---

## **STEP 9: Mount NAS on Mac (Persistent)**

**Open Finder on Mac:**

1. Press `Cmd + K` (Go → Connect to Server)
2. Enter: `smb://192.168.1.177`
3. Click **Connect**
4. Username: `nandez`
5. Password: Your NAS password
6. Check **"Remember this password in my keychain"**
7. Select folders to mount (check all 4)
8. Click **OK**

**Auto-mount on login:**

1. Go to **System Settings** → **General** → **Login Items**
2. Click **+** under "Open at Login"
3. Navigate to `/Volumes/development` (and other shares)
4. Add them all

**✅ Expected result:** NAS shares appear in Finder sidebar, auto-mount on boot

---

## **STEP 10: Install Docker Compose (if not included)**

**SSH back into NAS:**

```bash
ssh nandez@192.168.1.177
```

**Check if Docker Compose exists:**

```bash
docker compose version
```

**If not found, install it:**

```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

**✅ Expected result:** Docker Compose v2.x installed

---

## **STEP 11: Create Docker Directory Structure**

**✅ Setup script ready!** Copy it to NAS:

```bash
# From Mac
scp ~/Developer/temp-workspace/nas-configs/setup-nas-dirs.sh nandez@192.168.1.177:~
```

**Run on NAS:**

```bash
ssh nandez@192.168.1.177
bash ~/setup-nas-dirs.sh
ls -la /volume1/docker-data/
exit
```

**Or manual method:**

```bash
ssh nandez@192.168.1.177
mkdir -p /volume1/docker-data/{databases,services,backups}
mkdir -p /volume1/docker-data/databases/{postgres,mongodb,redis}
mkdir -p /volume1/docker-data/services/{nextcloud,photoprism,portainer}
chown -R $(whoami):$(whoami) /volume1/docker-data
chmod -R 755 /volume1/docker-data
ls -la /volume1/docker-data/
exit
```

**✅ Expected result:** Directory structure created

---

## **STEP 12: Add Mac SSH Key**

**✅ Already done!** SSH key was generated during prep: `~/.ssh/id_ed25519`

**Copy key to NAS:**

```bash
ssh-copy-id nandez@192.168.1.177
```

**Enter NAS password one last time**

**Test passwordless login:**

```bash
ssh nandez@192.168.1.177
# Or use shortcut: ssh nas
```

**✅ Expected result:** Logs in without asking for password

---

## **STEP 13: Environment Variables**

**✅ Already configured!** Your `.zshrc` has NAS aliases ready:

**Available commands:**

- `nas-ssh` - SSH to NAS
- `ssh nas` - Same (SSH shortcut)
- `nas-status` - Check NAS health
- `nas-docker` - List Docker containers
- `nas-deploy` - Deploy services (after setup)
- `nas-dev` - Navigate to /Volumes/development
- `nas-backup` - Navigate to /Volumes/backups
- `nas-cloud` - Navigate to /Volumes/cloud

**Test an alias:**

```bash
nas-ssh
# Should prompt for password (passwordless after Step 12)
exit
```

**✅ Expected result:** Commands work

---

## **STEP 14: Deploy Docker Services**

**✅ Docker configs already prepared!** Located in `~/Developer/temp-workspace/nas-configs/`

**Run automated deployment:**

```bash
# From NAS terminal (after ssh nas)
bash ~/setup-nas-dirs.sh

# Exit NAS and deploy from Mac
exit
nas-deploy
```

**Or manual method:**

```bash
# Copy files to NAS
scp ~/Developer/temp-workspace/nas-configs/docker-compose.yml nandez@192.168.1.177:/volume1/docker-data/

# SSH and start services
ssh nas
cd /volume1/docker-data
docker compose up -d
docker ps
exit
```

**⏳ This takes 2-5 minutes (downloading images)**

**✅ Expected result:** 3 containers running (postgres, redis, portainer)

---

## **STEP 15: Access Portainer (Docker GUI)**

**In browser on Mac:**

```
http://192.168.1.177:9000
```

**First-time setup:**

1. Create admin password
2. Click "Get Started"
3. Select "Local" environment

**✅ Expected result:** Portainer dashboard shows 3 running containers

---

## **STEP 16: Test Database Connections from Mac**

**✅ Database clients already installed!** (psql, redis-cli)

**Test PostgreSQL:**

```bash
psql -h 192.168.1.177 -U nandez -d postgres
# Password: changeme123
```

**If connected, you'll see:**

```
postgres=#
```

**Type `\q` to exit**

**Test Redis:**

```bash
redis-cli -h 192.168.1.177
```

**Type `ping` - should return `PONG`**

**Type `exit`**

**✅ Expected result:** Both databases accessible from Mac

---

# ✅ SETUP COMPLETE!

## 🎉 What You Can Do Now

### **From Mac:**

1. **Access NAS files:** Open Finder → See mounted shares in sidebar
2. **SSH into NAS:** `nas-ssh` (from any Terminal)
3. **Manage Docker:** `http://192.168.1.177:9000` (Portainer)
4. **Use databases:** Connect apps to `192.168.1.177:5432` (Postgres) or `:6379` (Redis)

### **From NAS:**

1. **View files:** `http://192.168.1.177` (web interface)
2. **Monitor RAID:** Control Panel → Storage Manager
3. **Docker logs:** Portainer or `docker logs <container>`

---

## 📋 Summary - What's Configured

| Component          | Status             | Access                 |
| ------------------ | ------------------ | ---------------------- |
| **NAS IP**         | 192.168.1.177      | Static (won't change)  |
| **RAID 5**         | Building (4-8 hrs) | ~12TB usable           |
| **SSH**            | ✅ Enabled         | `nas-ssh` or `ssh nas` |
| **Shared Folders** | ✅ 4 created       | Auto-mount on Mac      |
| **Docker**         | ✅ Running         | 3 services active      |
| **PostgreSQL**     | ✅ Running         | Port 5432              |
| **Redis**          | ✅ Running         | Port 6379              |
| **Portainer**      | ✅ Running         | Port 9000              |
| **Mac Tools**      | ✅ Installed       | psql, redis-cli        |
| **SSH Key**        | ✅ Generated       | Passwordless login     |

---

## 🔐 Important Info to Save

**NAS Admin Login:**

- URL: `http://192.168.1.177`
- Username: `nandez`
- Password: (your password)

**SSH:**

- Host: `192.168.1.177`
- User: `nandez`
- Password: (same as admin)

**PostgreSQL:**

- Host: `192.168.1.177`
- Port: `5432`
- User: `nandez`
- Password: `changeme123`
- Database: `postgres`

**Redis:**

- Host: `192.168.1.177`
- Port: `6379`
- No password (for now)

**Portainer:**

- URL: `http://192.168.1.177:9000`
- Admin: (password you set)

---

## 🚀 Next Steps

1. **Wait for RAID to finish building** (check in web UI)
2. **Install more services** (Nextcloud, PhotoPrism, etc.)
3. **Set up Time Machine backup** (use `backups` share)
4. **Start moving projects to NAS** (`/Volumes/development`)
5. **Order Mac mini M4 Pro** (AI workload server - see `my-ai-setup-decision.md`)
6. **Set up PC gaming console mode** (see `PC-Gaming-Console-AI-Setup.md` in OneDrive)

---

## 🔧 Troubleshooting

### **Can't find NAS IP**

```bash
# Try broadcast scan
ping -c 3 255.255.255.255
arp -a

# Or use UGREEN mobile app
# Download from App Store: "UGOS"
```

### **Can't SSH**

```bash
# Check if SSH is enabled in web UI
# Control Panel → Terminal & SNMP → Enable SSH

# Test connection
telnet 192.168.1.177 22
# Should show "SSH-2.0-OpenSSH..."
```

### **Shares not mounting**

```bash
# Check SMB is enabled
# NAS Web UI → Control Panel → File Services → SMB
# Enable SMB service

# Test from Mac
smbutil view //nandez@192.168.1.177
```

### **Docker not starting**

```bash
# Check Docker daemon
nas-ssh
systemctl status docker

# If not running
sudo systemctl start docker
sudo systemctl enable docker
```

---

**Setup guide ready!** Follow steps 1-16 in order. Let me know when NAS finishes booting and we'll start! 🎉
