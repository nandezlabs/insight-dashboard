#!/bin/bash

# Nginx Configuration Script for Hostinger VPS
# This script helps configure Nginx with SSL for the Insight backend

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}==================================="
echo "Insight Backend - Nginx Setup"
echo "===================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Get domain from user
read -p "Enter your domain name (e.g., yourdomain.com): " DOMAIN
read -p "Include www subdomain? (y/n): " INCLUDE_WWW

if [ "$INCLUDE_WWW" = "y" ]; then
    WWW_DOMAIN="www.$DOMAIN"
    SERVER_NAME="$DOMAIN $WWW_DOMAIN"
    CERT_DOMAINS="-d $DOMAIN -d $WWW_DOMAIN"
else
    SERVER_NAME="$DOMAIN"
    CERT_DOMAINS="-d $DOMAIN"
fi

echo -e "\n${GREEN}Step 1: Installing Nginx${NC}"
apt update
apt install -y nginx

echo -e "\n${GREEN}Step 2: Creating Nginx configuration${NC}"

# Create config file
cat > /etc/nginx/sites-available/insight << EOF
# Redirect HTTP to HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name $SERVER_NAME;

    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

# HTTPS Server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $SERVER_NAME;

    # SSL Configuration (will be added by Certbot)
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Logging
    access_log /var/log/nginx/insight-access.log;
    error_log /var/log/nginx/insight-error.log;

    # File upload size
    client_max_body_size 10M;

    # Proxy to backend
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    location /health {
        proxy_pass http://127.0.0.1:8000/health;
        access_log off;
    }
}
EOF

echo -e "${GREEN}✓ Configuration file created${NC}"

# Enable site
echo -e "\n${GREEN}Step 3: Enabling site${NC}"
ln -sf /etc/nginx/sites-available/insight /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test configuration
echo -e "\n${GREEN}Step 4: Testing Nginx configuration${NC}"
nginx -t

# Start Nginx
echo -e "\n${GREEN}Step 5: Starting Nginx${NC}"
systemctl restart nginx
systemctl enable nginx

echo -e "\n${GREEN}Step 6: Installing Certbot for SSL${NC}"
apt install -y certbot python3-certbot-nginx

echo -e "\n${GREEN}Step 7: Obtaining SSL certificate${NC}"
echo -e "${YELLOW}Note: Make sure your domain's A record points to this server's IP${NC}"
read -p "Continue with SSL certificate? (y/n): " CONTINUE_SSL

if [ "$CONTINUE_SSL" = "y" ]; then
    read -p "Enter your email address for Let's Encrypt: " EMAIL
    
    certbot --nginx $CERT_DOMAINS \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --redirect
    
    echo -e "${GREEN}✓ SSL certificate obtained and configured${NC}"
    
    # Test auto-renewal
    echo -e "\n${GREEN}Testing auto-renewal${NC}"
    certbot renew --dry-run
else
    echo -e "${YELLOW}Skipping SSL configuration. You can run it later with:${NC}"
    echo "sudo certbot --nginx $CERT_DOMAINS"
fi

# Configure firewall
echo -e "\n${GREEN}Step 8: Configuring firewall${NC}"
ufw allow 'Nginx Full'
ufw status

echo -e "\n${GREEN}==================================="
echo "✓ Nginx setup complete!"
echo "===================================${NC}"
echo ""
echo "Your API should now be accessible at:"
echo "  - https://$DOMAIN"
echo "  - https://$DOMAIN/docs (API documentation)"
echo ""
echo "Useful commands:"
echo "  - Check status: systemctl status nginx"
echo "  - View logs: tail -f /var/log/nginx/insight-error.log"
echo "  - Renew SSL: certbot renew"
echo "  - Test config: nginx -t"
echo ""
