#!/bin/bash
# Quick run scripts for individual roles

# Activate virtual environment if it exists
if [ -d ".venv" ]; then
    source .venv/bin/activate
elif [ -d "vault-ansible" ]; then
    source vault-ansible/bin/activate
fi

echo "Vault Ansible Playbook Runner"
echo "=============================="

case "$1" in
  "test-dev"|"td")
    echo "Running Test Environment Configuration (Dev Vault - Port 8200)..."
    ansible-playbook -i inventories/test playbooks/test-dev-vault.yml --limit vault_dev
    ;;
  "test-simple"|"ts")
    echo "Running Simple Test Environment Configuration (Dev Vault - No Sudo)..."
    ansible-playbook -i inventories/test playbooks/test-simple.yml --limit vault_dev
    ;;
  "test-prod"|"tp")
    echo "Running Test Environment Configuration (Prod Vault - Port 8202)..."
    ansible-playbook -i inventories/test playbooks/test-prod-vault.yml --limit vault_prod_test
    ;;
  "init")
    echo "Running Vault initialization..."
    ansible-playbook -i inventories/test playbooks/init-only.yml
    ;;
  "audit")
    echo "Running Vault audit configuration..."
    ansible-playbook -i inventories/test playbooks/audit-only.yml
    ;;
  "policies")
    echo "Running Vault policy configuration..."
    ansible-playbook -i inventories/test playbooks/policies-only.yml
    ;;
  "all")
    echo "Running complete Vault configuration..."
    ansible-playbook -i inventories/test site.yml
    ;;
  "prod-init")
    echo "Running Vault initialization (Production)..."
    ansible-playbook -i inventories/production playbooks/init-only.yml
    ;;
  "prod-audit")
    echo "Running Vault audit configuration (Production)..."
    ansible-playbook -i inventories/production playbooks/audit-only.yml
    ;;
  "prod-policies")
    echo "Running Vault policy configuration (Production)..."
    ansible-playbook -i inventories/production playbooks/policies-only.yml
    ;;
  "prod-all")
    echo "Running complete Vault configuration (Production)..."
    ansible-playbook -i inventories/production site.yml
    ;;
  *)
    echo "Usage: $0 {command}"
    echo ""
    echo "Test Environment Commands:"
    echo "  test-dev  (td)    - Configure dev vault (port 8200, pre-initialized)"
    echo "  test-simple (ts)  - Simple dev vault setup (no sudo required)"
    echo "  test-prod (tp)    - Configure prod vault (port 8202, needs init)"
    echo ""
    echo "Individual Component Commands:"
    echo "  init              - Initialize Vault only"
    echo "  audit             - Configure audit logging only"
    echo "  policies          - Configure policies only"
    echo "  all               - Run complete configuration"
    echo ""
    echo "Production Environment Commands:"
    echo "  prod-init         - Initialize Vault only (production)"
    echo "  prod-audit        - Configure audit logging only (production)"
    echo "  prod-policies     - Configure policies only (production)"
    echo "  prod-all          - Run complete configuration (production)"
    echo ""
    echo "Examples:"
    echo "  $0 test-simple            # Simple dev vault setup (recommended)"
    echo "  $0 test-dev               # Full dev vault with all roles"
    echo "  $0 test-prod              # Initialize production-like vault"
    echo "  $0 ts                     # Short form for test-simple"
    exit 1
    ;;
esac