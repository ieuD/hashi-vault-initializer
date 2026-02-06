#!/bin/bash
set -e

echo "Creating simple Vault test environment..."

# Stop and clean up
docker-compose down -v

# Create local directories for Vault data
mkdir -p ./vault-data ./vault-logs

# Set proper permissions
chmod 755 ./vault-data ./vault-logs

# Start containers
docker-compose up -d

echo "Waiting for Vault to start..."
sleep 15

echo "Vault should now be ready for initialization!"
echo "Test with: curl http://localhost:8200/v1/sys/init"
echo "Initialize with: ./run-playbook.sh init"