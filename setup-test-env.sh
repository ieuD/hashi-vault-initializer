#!/bin/bash
set -e

echo "Setting up Vault test environment with proper permissions..."

# Stop any existing containers
echo "Stopping existing containers..."
docker-compose down

# Remove existing volumes to start fresh
echo "Removing existing volumes..."
docker-compose down -v

# Create the volumes first and set permissions
echo "Creating volumes with proper permissions..."
docker volume create vault-initializer_vault-data
docker volume create vault-initializer_vault-logs
docker volume create vault-initializer_vault-config

# Set permissions on the volumes using a temporary container
echo "Setting proper permissions on volumes..."
docker run --rm -v vault-initializer_vault-data:/vault/data -v vault-initializer_vault-logs:/vault/logs -v vault-initializer_vault-config:/vault/config alpine:latest sh -c '
  chown -R 100:1000 /vault/data /vault/logs /vault/config
  chmod -R 755 /vault/data /vault/logs /vault/config
'

# Start the services
echo "Starting Vault containers..."
docker-compose up -d

# Wait for Vault to be ready
echo "Waiting for Vault to be ready..."
sleep 15

# Check if Vault is accessible
echo "Checking Vault status..."
for i in {1..30}; do
  if curl -s http://localhost:8200/v1/sys/health >/dev/null 2>&1; then
    echo "Vault is ready!"
    break
  fi
  echo "Waiting for Vault... ($i/30)"
  sleep 2
done

# Check dev vault
echo "Checking Dev Vault status..."
curl -s http://localhost:8201/v1/sys/health || echo "Dev Vault not ready yet"

echo ""
echo "Test environment setup complete!"
echo ""
echo "Services available:"
echo "- Production Vault: http://localhost:8200 (requires initialization)"
echo "- Development Vault: http://localhost:8201 (dev mode, root token: devroot)"
echo ""
echo "To initialize the production Vault:"
echo "./run-playbook.sh init"
echo ""
echo "To run the complete playbook:"
echo "./run-playbook.sh all"
echo ""
echo "To stop the environment:"
echo "docker-compose down"
echo ""
echo "To completely reset:"
echo "docker-compose down -v && ./setup-test-env.sh"