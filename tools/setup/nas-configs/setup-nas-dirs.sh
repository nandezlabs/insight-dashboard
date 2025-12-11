#!/bin/bash
# Run this on NAS after SSH is enabled
# Creates directory structure for Docker

set -e

echo "Creating NAS directory structure..."

# Create base directories
mkdir -p /volume1/docker-data/{databases,services,backups}
mkdir -p /volume1/docker-data/databases/{postgres,mongodb,redis}
mkdir -p /volume1/docker-data/services/{nextcloud,photoprism,portainer}

# Set permissions
chown -R $(whoami):$(whoami) /volume1/docker-data
chmod -R 755 /volume1/docker-data

echo "✅ Directory structure created:"
ls -la /volume1/docker-data/
