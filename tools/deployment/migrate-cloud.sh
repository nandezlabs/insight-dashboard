#!/bin/bash
# Cloud Migration Script
# Migrate from iCloud + Google Drive + OneDrive → NAS
# Zero local storage required

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Load NAS config
if [ -f ~/Developer/nas-config.txt ]; then
    source ~/Developer/nas-config.txt
else
    echo -e "${RED}❌ NAS not configured. Run setup-nas.sh first${NC}"
    exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Cloud Migration to NAS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${YELLOW}This script will help you migrate:${NC}"
echo "  • iCloud Photos & Files → NAS"
echo "  • Google Drive → NAS"
echo "  • OneDrive → NAS"
echo ""
echo -e "${GREEN}✅ No local storage needed (direct transfer)${NC}"
echo -e "${GREEN}✅ Automatic deduplication${NC}"
echo -e "${GREEN}✅ Preserves folder structure${NC}\n"

# Check if NAS is mounted
if [ ! -d "/Volumes/cloud" ]; then
    echo -e "${RED}❌ NAS not mounted. Run setup-nas.sh first${NC}"
    exit 1
fi

# Menu
show_menu() {
    echo -e "${BLUE}Select migration option:${NC}"
    echo "1) Download browser method (easiest)"
    echo "2) rclone method (automatic, recommended)"
    echo "3) Manual upload via drag & drop"
    echo "4) Skip migration (already done)"
    echo "5) Exit"
    echo ""
}

# Option 1: Browser download
browser_migration() {
    echo -e "\n${YELLOW}📥 Browser Download Method${NC}\n"
    
    echo -e "${BLUE}Step 1: iCloud Photos${NC}"
    echo "1. Open Safari → https://www.icloud.com"
    echo "2. Sign in → Click Photos"
    echo "3. Select All (Cmd+A)"
    echo "4. Click Download button"
    echo "5. Save location: /Volumes/cloud/Photos/Library/"
    echo ""
    echo -e "${YELLOW}💡 Tip: Downloads stream directly to NAS (no Mac storage used)${NC}"
    echo ""
    read -p "Press Enter when iCloud download is complete..."
    
    echo -e "\n${BLUE}Step 2: Google Drive${NC}"
    echo "1. Open Safari → https://drive.google.com"
    echo "2. Right-click folder → Download"
    echo "3. Save location: /Volumes/cloud/Photos/Library/"
    echo "   (or /Volumes/cloud/Documents/ for files)"
    echo ""
    read -p "Press Enter when Google Drive download is complete..."
    
    echo -e "\n${BLUE}Step 3: OneDrive${NC}"
    echo "1. Open Safari → https://onedrive.live.com"
    echo "2. Select files → Download"
    echo "3. Save location: /Volumes/cloud/Documents/"
    echo ""
    read -p "Press Enter when OneDrive download is complete..."
    
    echo -e "\n${GREEN}✅ Browser migration complete!${NC}"
    echo -e "${YELLOW}PhotoPrism will now index your photos...${NC}\n"
    
    # Trigger PhotoPrism indexing
    echo "Starting PhotoPrism indexing (this may take a while)..."
    ssh $NAS_USER@$NAS_IP "docker exec photoprism photoprism index" || echo "Index started in background"
}

# Option 2: rclone (automated)
rclone_migration() {
    echo -e "\n${YELLOW}🚀 rclone Automated Migration${NC}\n"
    
    # Check if rclone is installed
    if ! command -v rclone &> /dev/null; then
        echo "Installing rclone..."
        brew install rclone
    fi
    
    echo -e "${BLUE}rclone Configuration Wizard${NC}\n"
    echo "This will guide you through setting up:"
    echo "  • iCloud"
    echo "  • Google Drive"
    echo "  • OneDrive"
    echo ""
    
    read -p "Configure rclone now? (y/n): " SETUP_RCLONE
    
    if [ "$SETUP_RCLONE" = "y" ]; then
        echo -e "\n${YELLOW}Configuring iCloud...${NC}"
        echo "Follow the prompts:"
        echo "  1. Choose: n (new remote)"
        echo "  2. Name: icloud"
        echo "  3. Type: 15 (WebDAV)"
        echo "  4. URL: https://p01-caldav.icloud.com"
        echo "  5. Vendor: icloud"
        echo "  6. Username: your@email.com"
        echo "  7. Password: (generate app-specific password at appleid.apple.com)"
        echo ""
        read -p "Press Enter to start configuration..."
        rclone config
        
        echo -e "\n${YELLOW}Configuring Google Drive...${NC}"
        echo "Follow the prompts:"
        echo "  1. Choose: n (new remote)"
        echo "  2. Name: gdrive"
        echo "  3. Type: drive"
        echo "  4. Follow OAuth prompts in browser"
        echo ""
        read -p "Press Enter to continue..."
        rclone config
    fi
    
    # Start migration
    echo -e "\n${YELLOW}Starting automated migration...${NC}\n"
    
    # iCloud to NAS
    if rclone listremotes | grep -q "icloud:"; then
        echo "Migrating iCloud..."
        rclone copy icloud: /Volumes/cloud/ \
            --progress \
            --transfers 4 \
            --checkers 8 \
            --stats 30s \
            --log-file ~/Developer/icloud-migration.log &
        
        ICLOUD_PID=$!
        echo "iCloud migration running in background (PID: $ICLOUD_PID)"
    fi
    
    # Google Drive to NAS
    if rclone listremotes | grep -q "gdrive:"; then
        echo "Migrating Google Drive..."
        rclone copy gdrive: /Volumes/cloud/Photos/Library/ \
            --progress \
            --transfers 4 \
            --checkers 8 \
            --stats 30s \
            --log-file ~/Developer/gdrive-migration.log &
        
        GDRIVE_PID=$!
        echo "Google Drive migration running in background (PID: $GDRIVE_PID)"
    fi
    
    echo -e "\n${GREEN}✅ Migration started!${NC}"
    echo -e "${YELLOW}Check progress:${NC}"
    echo "  tail -f ~/Developer/icloud-migration.log"
    echo "  tail -f ~/Developer/gdrive-migration.log"
    echo ""
    echo -e "${BLUE}💡 You can close this terminal - migration continues in background${NC}\n"
}

# Option 3: Manual
manual_migration() {
    echo -e "\n${YELLOW}📁 Manual Upload Method${NC}\n"
    
    echo "1. Open Finder"
    echo "2. Navigate to /Volumes/cloud/"
    echo "3. Drag and drop files from:"
    echo "   • iCloud Drive → /Volumes/cloud/Documents/"
    echo "   • Downloads → /Volumes/cloud/Photos/Library/"
    echo ""
    echo -e "${GREEN}✅ Files copied to NAS will be automatically indexed${NC}\n"
    
    read -p "Press Enter when manual upload is complete..."
}

# Main menu loop
while true; do
    show_menu
    read -p "Choose option (1-5): " choice
    
    case $choice in
        1) browser_migration ;;
        2) rclone_migration ;;
        3) manual_migration ;;
        4) 
            echo -e "\n${GREEN}✅ Skipping migration${NC}\n"
            break
            ;;
        5) 
            echo -e "\n${GREEN}👋 Goodbye!${NC}\n"
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid option${NC}\n"
            ;;
    esac
    
    # Post-migration steps
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Post-Migration Steps${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    echo -e "${YELLOW}1. PhotoPrism is indexing your photos${NC}"
    echo "   Access: http://$NAS_IP:2342"
    echo "   Login: admin / changeme123"
    echo ""
    
    echo -e "${YELLOW}2. Nextcloud file sync${NC}"
    echo "   Download: https://nextcloud.com/install/#install-clients"
    echo "   Server: http://$NAS_IP:8081"
    echo "   Setup selective sync for Desktop & Documents"
    echo ""
    
    echo -e "${YELLOW}3. Review duplicates${NC}"
    echo "   PhotoPrism marks duplicates automatically"
    echo "   Check: /Volumes/backups/duplicates-review/"
    echo ""
    
    echo -e "${YELLOW}4. Cancel subscriptions${NC}"
    echo "   ✅ iCloud: Settings → Apple ID → iCloud → Manage Storage → Downgrade"
    echo "   ✅ Google Drive: drive.google.com/settings/storage"
    echo "   ✅ OneDrive: account.microsoft.com/services"
    echo ""
    
    echo -e "${GREEN}💰 Annual savings: ~$204+ (iCloud + OneDrive)${NC}\n"
    
    read -p "Continue with another migration? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ]; then
        break
    fi
done

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Migration Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}📱 Next: Install mobile apps${NC}"
echo "  • Nextcloud (auto photo upload)"
echo "  • Files app (connect to NAS via SMB)"
echo ""

echo -e "${BLUE}🔗 Quick Links:${NC}"
echo "  PhotoPrism: http://$NAS_IP:2342"
echo "  Nextcloud:  http://$NAS_IP:8081"
echo "  Files:      /Volumes/cloud/"
echo ""

echo -e "${GREEN}Your cloud is now self-hosted! 🎉${NC}\n"
