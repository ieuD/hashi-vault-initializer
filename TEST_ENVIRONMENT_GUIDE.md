# 🏗️ Vault Test Environment - Quick Reference

## 🚀 Quick Start

```bash
# 1. Start containers
docker-compose -f docker-compose-simple.yml up -d

# 2. Configure test environment (recommended)
./run-playbook.sh test-simple

# 3. Open Vault UI
open http://localhost:8200/ui
```

## 🔑 Login Credentials

### Root Access
- **Token**: `myroot`
- **Usage**: Full administrative access

### Test Users (Username/Password)
- **testuser** / `testpass123` - Limited to `secret/test/*` paths
- **admin** / `admin123` - Full administrative access  
- **readonly** / `readonly123` - Read-only access to `secret/test/*`

## 🌐 Web UI Access

| Environment    | URL                      | Status       | Purpose                          |
| -------------- | ------------------------ | ------------ | -------------------------------- |
| **Dev Vault**  | http://localhost:8200/ui | ✅ Ready      | Testing with pre-configured data |
| **Prod Vault** | http://localhost:8202/ui | ⚠️ Needs Init | Production-like testing          |

## 📂 Test Data Available

### Secrets (Path: `secret/test/`)
- **database** - Database connection details
- **api** - API keys and endpoints  
- **config** - Application configuration

### Policies
- **test-admin** - Full access to everything
- **test-user** - Limited to `secret/test/*` paths
- **test-readonly** - Read-only access

## 🎯 Solving Your UI Login Issue

### Method 1: Root Token (Easiest)
1. Open http://localhost:8200/ui
2. Select **Token** method
3. Enter token: `myroot`
4. Click **Sign In**

### Method 2: Username/Password  
1. Open http://localhost:8200/ui
2. Select **Username** method
3. Try any test user:
   - Username: `admin` / Password: `admin123`
   - Username: `testuser` / Password: `testpass123`

## 🛠️ Available Commands

```bash
# Test environment setup
./run-playbook.sh test-simple     # ✅ No sudo required
./run-playbook.sh ts              # Short form

# Production-like testing  
./run-playbook.sh test-prod       # Initialize production vault
./run-playbook.sh tp              # Short form

# Individual components
./run-playbook.sh init            # Initialize only
./run-playbook.sh audit           # Audit logging only
./run-playbook.sh policies        # Policies only
```

## 🔍 Troubleshooting

### "Permission Denied" in UI
- ✅ **Solution**: Use `./run-playbook.sh test-simple` 
- This creates proper users and policies

### "Connection Refused"
- Check containers: `docker ps`
- Restart if needed: `docker-compose -f docker-compose-simple.yml restart`

### View Audit Logs
```bash
tail -f /tmp/vault-audit-test.log
```

### Reset Everything  
```bash
docker-compose down -v
./setup-simple.sh
./run-playbook.sh test-simple
```

## 🎭 Different Environment Overrides

### For Dev Testing (Port 8200)
```yaml
# group_vars/test.yml
vault_addr: "http://localhost:8200"
vault_token: "myroot"
```

### For Prod Testing (Port 8202)  
```yaml
# group_vars/production.yml
vault_addr: "http://localhost:8202"
vault_force_init: true
```

### Command Line Overrides
```bash
# Use different vault instance
./run-playbook.sh test-simple -e vault_addr=http://localhost:8202

# Force reinitialization
./run-playbook.sh test-simple -e vault_force_init=true
```

---
**🎉 You're all set!** Your test environment is ready with users, policies, and test data.