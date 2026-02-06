#!/bin/bash
set -e

echo "Fixing Vault permissions issue..."

# Stop containers
docker-compose down

# Fix permissions on existing volumes
echo "Fixing permissions on Docker volumes..."
docker run --rm -v vault-initializer_vault-data:/vault/data -v vault-initializer_vault-logs:/vault/logs -v vault-initializer_vault-config:/vault/config alpine:latest sh -c '
  chown -R 100:1000 /vault/data /vault/logs /vault/config
  chmod -R 755 /vault/data /vault/logs /vault/config
'

# Restart
echo "Starting Vault with fixed permissions..."
docker-compose up -d

echo "Permissions fixed! Vault should now start properly."
echo "Wait a moment and then try initializing with:"
echo "./run-playbook.sh init"