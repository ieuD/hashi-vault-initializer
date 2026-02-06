#!/bin/bash
# Test Environment Demo Script
# ===========================

set -e

echo "Vault Test Environment Demo"
echo "=========================="
echo ""

# Check if containers are running
echo "1. Checking Docker containers..."
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}" | grep vault || echo "No vault containers found"
echo ""

# Check vault status
echo "2. Checking Vault status..."
echo "Dev Vault (port 8200):"
curl -s http://localhost:8200/v1/sys/init | jq -r '.initialized // "Not accessible"' 2>/dev/null || echo "Not accessible"

echo "Prod Vault (port 8202):"
curl -s http://localhost:8202/v1/sys/init | jq -r '.initialized // "Not accessible"' 2>/dev/null || echo "Not accessible"
echo ""

# Configure dev vault
echo "3. Configuring Dev Vault (port 8200) with test data..."
./run-playbook.sh test-dev
echo ""

# Show login instructions
echo "4. Test Environment Ready!"
echo "========================"
echo ""
echo "🌐 Web UI Access:"
echo "  Dev Vault:  http://localhost:8200/ui"
echo "  Prod Vault: http://localhost:8202/ui"
echo ""
echo "🔑 Login Credentials:"
echo ""
echo "  Root Token (dev): myroot"
echo "  Test Users:"
echo "    - Username: testuser, Password: testpass123 (test-user policy)"
echo "    - Username: admin,    Password: admin123    (test-admin policy)"  
echo "    - Username: readonly, Password: readonly123 (test-readonly policy)"
echo ""
echo "🧪 Test Secrets Created:"
echo "  - secret/test/database (database credentials)"
echo "  - secret/test/api      (API configuration)"
echo "  - secret/test/config   (application config)"
echo ""
echo "📋 Next Steps:"
echo "  1. Open http://localhost:8200/ui in your browser"
echo "  2. Login with root token 'myroot' or test users above"
echo "  3. Explore the secrets under 'secret/test/'"
echo "  4. Try the policies by switching between users"
echo ""
echo "🔧 To initialize Production Vault:"
echo "  ./run-playbook.sh test-prod"
echo ""
echo "📖 View audit logs:"
echo "  tail -f /tmp/vault-audit-test.log"