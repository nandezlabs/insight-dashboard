# 🔧 NAS Troubleshooting Guide

**Created:** December 10, 2025  
**Issue:** NAS not connecting after reset  
**Status:** Active troubleshooting

---

## 🚨 Immediate Checks (5 minutes)

### Step 1: Physical Connections

```bash
# Check these in order:
□ Power cable firmly connected to NAS
□ Power LED is on (solid or blinking)
□ Ethernet cable connected to NAS and router
□ Ethernet port LED blinking on NAS
□ Router port LED blinking where NAS is connected
□ No physical damage to cables
```

**Try:**

- Unplug power for 30 seconds, plug back in
- Try different Ethernet cable
- Try different router port
- Ensure both ends of Ethernet cable click firmly

---

### Step 2: Network Detection

**Find your NAS on the network:**

```bash
# Option 1: Check router's device list
# Open router admin: http://192.168.1.1 (or your router IP)
# Look for connected devices
# Find "Synology" or "NAS" or unknown device

# Option 2: Scan network from Mac
# Install nmap if needed:
brew install nmap

# Scan your network (adjust IP range):
nmap -sn 192.168.1.0/24

# Look for your NAS IP in results

# Option 3: Use Synology Assistant (if Synology NAS)
# Download from: https://www.synology.com/support/download
# Run Synology Assistant
# It will auto-discover NAS on network

# Option 4: Ping common NAS IPs
ping 192.168.1.100  # Common NAS IP
ping 192.168.1.50
ping 192.168.0.100

# Option 5: Check ARP cache
arp -a | grep -i synology
# Or look for recently seen IPs
```

---

## 🔍 Step-by-Step Troubleshooting

### Problem 1: Can't Find NAS IP Address

**Symptoms:**

- NAS not showing in router device list
- Can't ping NAS
- Synology Assistant doesn't find it

**Solutions:**

**A. Reset Network Settings (Synology):**

```bash
# Physical button method:
1. Locate reset button on back of NAS (pinhole)
2. While NAS is ON, press and hold for 4 seconds
3. Hear one beep
4. Release button
5. Network settings reset to DHCP
6. Wait 2 minutes for NAS to obtain IP
7. Check router's DHCP client list for new device
```

**B. Direct Connection Method:**

```bash
# Connect Mac directly to NAS (no router):
1. Unplug NAS from router
2. Connect Ethernet cable from Mac to NAS directly
3. On Mac: System Settings → Network → Ethernet
4. Configure IPv4: Manually
   - IP Address: 192.168.1.2
   - Subnet Mask: 255.255.255.0
   - Router: (leave blank)
5. Try accessing: http://192.168.1.1 or http://192.168.1.100
6. Or run Synology Assistant to find it

# If found, you can now configure network settings
```

**C. Check DHCP on Router:**

```bash
# Ensure DHCP is enabled on router:
1. Access router admin (usually http://192.168.1.1)
2. Look for DHCP settings
3. Ensure DHCP Server is enabled
4. Check DHCP range (e.g., 192.168.1.100 - 192.168.1.200)
5. Ensure range has available IPs
6. Save and reboot router if changed

# Reserve IP for NAS (recommended):
1. Find NAS MAC address (written on device or in admin)
2. In router: DHCP → Static IP Reservation
3. Add reservation: MAC address → specific IP (e.g., 192.168.1.50)
4. Save settings
5. Reboot NAS
```

---

### Problem 2: Know IP But Can't Access Web Interface

**Symptoms:**

- Can ping NAS successfully
- But browser shows "Connection refused" or times out

**Solutions:**

**A. Check Services:**

```bash
# Test if NAS responds:
ping <nas-ip>

# Check if web service is running:
curl -I http://<nas-ip>:5000  # Synology default port

# Try different ports:
http://<nas-ip>:5000    # Synology DSM
http://<nas-ip>:5001    # Synology HTTPS
http://<nas-ip>:80      # Standard HTTP
http://<nas-ip>:8080    # Alternative HTTP

# Test SSH (if enabled):
ssh admin@<nas-ip>
```

**B. Browser Issues:**

```bash
# Clear browser cache:
# Chrome: Cmd+Shift+Delete
# Safari: Cmd+Option+E

# Try different browsers:
- Chrome
- Safari
- Firefox

# Try incognito/private mode

# Disable browser extensions temporarily

# Try from different device (phone, tablet)
```

**C. Firewall Issues:**

```bash
# Temporarily disable Mac firewall:
System Settings → Network → Firewall → Turn Off
# Try accessing NAS
# Remember to turn back on after testing

# Check if Mac is blocking connection:
sudo pfctl -s rules | grep <nas-ip>
```

---

### Problem 3: Services Not Starting After Reset

**Symptoms:**

- Can access web interface
- But services (file sharing, Docker, etc.) not working

**Solutions:**

**A. Check DSM Status:**

```bash
# In DSM web interface:
1. Control Panel → Info Center
2. Check system status
3. Look for services in "Starting" state

# Check Resource Monitor:
1. Main Menu → Resource Monitor
2. Check CPU, RAM, Network usage
3. High CPU might indicate stuck service
```

**B. Restart Services Manually:**

```bash
# In DSM:
1. Control Panel → Service Portal (or specific service)
2. Stop service
3. Wait 30 seconds
4. Start service

# For File Station:
Control Panel → File Services → Enable SMB/AFP/NFS

# For Docker:
Package Center → Docker → Stop → Start

# For Plex/media services:
Package Center → [Service] → Stop → Start
```

**C. Full System Restart:**

```bash
# Safe restart:
1. In DSM: Control Panel → Power → Restart
2. Wait 5-10 minutes for full restart

# Or via SSH:
ssh admin@<nas-ip>
sudo reboot

# Hard restart (last resort):
1. Hold power button for 4 seconds
2. Wait for beep
3. NAS will shut down
4. Wait 30 seconds
5. Press power button to start
```

---

### Problem 4: Can Connect But Data/Shares Missing

**Symptoms:**

- NAS accessible
- But folders/data not visible
- Or permission denied errors

**Solutions:**

**A. Check Volume Status:**

```bash
# In DSM:
1. Storage Manager
2. Check if volumes are mounted
3. Look for "Normal" status
4. If degraded/crashed, follow volume repair

# Check drives:
Storage Manager → HDD/SSD
- All drives should show "Normal"
- If any show errors, investigate drive health
```

**B. Check Shared Folders:**

```bash
# In DSM:
1. Control Panel → Shared Folder
2. Verify folders exist
3. Check permissions
4. Ensure "Hide from network" is unchecked

# Reset permissions if needed:
Right-click folder → Edit → Permissions
Add back user access
```

**C. Remount Shares on Mac:**

```bash
# Disconnect existing connections:
Finder → Go → Connect to Server (Cmd+K)
# Remove old connections

# Reconnect:
smb://<nas-ip>/shared-folder

# Or use Finder:
Finder → Network → [NAS Name]

# If prompted for credentials:
Username: your-nas-username
Password: your-nas-password
```

---

## 🔧 Advanced Troubleshooting

### Network Configuration Issues

**Check Network Settings in DSM:**

```bash
# After accessing DSM:
1. Control Panel → Network → Network Interface
2. Check LAN settings:
   - IPv4: DHCP or Manual
   - If Manual: Correct IP, subnet, gateway
   - DNS: Router IP or 8.8.8.8, 8.8.4.4

3. Test connectivity:
   Control Panel → Network → General
   Click "Test Connection"

# Recommended settings:
IPv4 Configuration: Use DHCP (unless you need static)
DNS Server: Automatic (from DHCP) or Manual (8.8.8.8, 8.8.4.4)
```

**Static IP Configuration (if needed):**

```bash
# In DSM:
1. Control Panel → Network → Network Interface
2. Select LAN → Edit
3. IPv4: Use Manual Configuration
   - IP Address: 192.168.1.50 (or your choice)
   - Subnet Mask: 255.255.255.0
   - Gateway: 192.168.1.1 (your router IP)
4. DNS Server: Manual
   - Primary: 8.8.8.8
   - Secondary: 8.8.4.4
5. Apply

# Then update your router's DHCP reservation to match
```

---

### Hardware Diagnostics

**Check Drive Health:**

```bash
# In DSM:
1. Storage Manager → HDD/SSD
2. Select each drive
3. Click "Health Info"
4. Check S.M.A.R.T. status
5. Run S.M.A.R.T. test if needed

# Warning signs:
- Reallocated sectors > 0
- Current pending sectors > 0
- Temperature > 50°C
- Bad sectors
```

**Check System Logs:**

```bash
# In DSM:
1. Log Center
2. Check for errors around reset time
3. Filter by:
   - System
   - Connection
   - Storage

# Look for:
- Connection failures
- Drive errors
- Service crashes
- Network errors
```

---

### Factory Reset (Nuclear Option)

**⚠️ WARNING: This erases ALL data!**

```bash
# Before factory reset:
1. Backup all data if possible
2. Document all settings
3. List all installed packages
4. Export configurations

# Factory Reset Procedure:
1. Power off NAS
2. Remove ALL hard drives
3. Power on NAS (empty)
4. Press and hold reset button for 10 seconds
5. Release when you hear beeps
6. Wait for reset to complete
7. Power off
8. Reinstall hard drives
9. Power on
10. Follow setup wizard

# Alternative (keeps data):
1. In DSM: Control Panel → Update & Restore
2. Configuration Backup → Export
3. Reset → Reset to default
4. Wait for reset
5. Reconfigure manually or import backup
```

---

## 📝 Common Issues & Quick Fixes

### Issue: "Network error" when accessing DSM

```bash
Solution:
1. Restart NAS
2. Clear browser cache
3. Try different browser
4. Check if firewall is blocking
```

### Issue: Very slow access

```bash
Solution:
1. Check network cable (Cat5e minimum, Cat6 recommended)
2. Check router port speed (should be 1000 Mbps)
3. Restart router
4. Check CPU usage in Resource Monitor
5. Check if indexing is running
```

### Issue: Can't mount shares on Mac

```bash
Solution:
1. Check SMB is enabled: Control Panel → File Services
2. Enable SMB1 if using old Mac (not recommended)
3. Check firewall on Mac
4. Try: smb://<ip>/shared-folder instead of AFP
5. Verify user has permission to share
```

### Issue: Docker containers not starting

```bash
Solution:
1. Package Center → Docker → Repair
2. Check storage space (need 10%+ free)
3. Check logs: Docker → Container → Logs
4. Restart Docker service
5. Rebuild container if needed
```

---

## 🛠️ Prevention & Best Practices

### Regular Maintenance

```bash
Weekly:
- Check system health in DSM
- Verify backups completed
- Check available storage

Monthly:
- Update DSM if new version available
- Check drive health (S.M.A.R.T.)
- Review system logs
- Test restore from backup

Quarterly:
- Run extended S.M.A.R.T. tests
- Clean dust from NAS
- Check fan operation
- Update all packages
```

### Backup Important Configs

```bash
# Before any major change:
1. Control Panel → Update & Restore
2. Configuration Backup → Backup
3. Download and save .dss file
4. Document:
   - IP address/network settings
   - User accounts
   - Shared folder names
   - Installed packages
   - Docker containers
```

### Network Stability

```bash
# Use Static IP or DHCP Reservation:
1. Prevents IP changes
2. Easier to connect
3. More reliable

# Use Quality Cables:
- Cat6 or better
- Shielded if near interference
- No longer than needed
- Replace if damaged

# Router Settings:
- Enable QoS for NAS (if available)
- Disable power saving on router
- Keep router firmware updated
```

---

## 📞 Getting Help

### Information to Gather

```bash
Before asking for help:
□ NAS model and DSM version
□ Network topology (router model, setup)
□ What changed before issue started
□ Error messages (screenshots)
□ What you've already tried
□ System logs from Log Center
□ Output of: nmap -sn 192.168.1.0/24
```

### Where to Ask

```
Synology Forum:
https://community.synology.com

Reddit:
r/synology

Discord:
Synology Community Discord

Official Support:
https://www.synology.com/support
```

---

## ✅ Quick Diagnostic Checklist

```bash
Run through this checklist:

Physical:
□ Power LED on
□ Ethernet cable connected
□ Router port LED blinking
□ Tried different cable
□ Tried different router port

Network:
□ Can find IP with nmap or Synology Assistant
□ Can ping NAS
□ Router shows NAS as connected
□ DHCP is enabled on router

Access:
□ Can access web interface (http://<ip>:5000)
□ Can login with credentials
□ Services are running
□ No error messages in Log Center

Data:
□ Volumes show as "Normal"
□ Shared folders are visible
□ Can mount shares on Mac
□ Data is accessible

If all checked but still issues:
→ Check system logs
→ Run hardware diagnostics
→ Consider reinstalling DSM
```

---

## 🚀 Quick Recovery Commands

```bash
# Find NAS on network
nmap -sn 192.168.1.0/24
nmap -sn 192.168.0.0/24

# Check if NAS responds
ping -c 4 192.168.1.50

# Test web service
curl -I http://192.168.1.50:5000

# Check ARP table
arp -a | grep -E "(192\.168\.(0|1)\.)"

# Mount NAS share
open "smb://192.168.1.50/shared-folder"

# Scan for open ports on NAS
nmap -p 22,80,443,5000,5001 192.168.1.50

# SSH into NAS (if enabled)
ssh admin@192.168.1.50
# Then check status:
# cat /var/log/messages
# ifconfig
# ps aux | grep synoscgi
```

---

**Next Steps:**

1. Start with "Immediate Checks"
2. Work through "Step-by-Step Troubleshooting"
3. Document what works/doesn't work
4. If still stuck after 2 hours, contact support

**Remember:** Most NAS connection issues are network-related (IP, cables, router) rather than NAS hardware failures.

---

**Version:** 1.0  
**Last Updated:** December 10, 2025  
**Status:** Active troubleshooting document
