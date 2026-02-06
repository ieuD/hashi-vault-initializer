# Example Vault Policy Usage

After running the playbook, you can use the policies in various ways:

## 1. Create a Token with Policy

```bash
# Create a token with app-secrets policy
vault token create -policy=app-secrets -ttl=1h

# Create a token with multiple policies  
vault token create -policy=app-secrets -policy=read-only -ttl=1h
```

## 2. Assign Policy to UserPass User

```bash
# Enable userpass auth method
vault auth enable userpass

# Create user with policy
vault write auth/userpass/users/appuser \
    password=mypassword \
    policies=app-secrets

# Login as user
vault login -method=userpass username=appuser password=mypassword
```

## 3. Assign Policy to AppRole

```bash  
# Enable AppRole auth method
vault auth enable approle

# Create AppRole with policy
vault write auth/approle/role/my-app-role \
    policies=app-secrets \
    token_ttl=1h \
    token_max_ttl=4h

# Get role ID and secret ID
vault read auth/approle/role/my-app-role/role-id
vault write -f auth/approle/role/my-app-role/secret-id
```

## 4. Test Policy Permissions

```bash
# Test with app-secrets policy token
export VAULT_TOKEN="s.xxxxxxxxx"

# Should work - app path
vault kv put secret/app/database username=myuser password=mypass

# Should fail - outside app path  
vault kv put secret/other/database username=myuser password=mypass
```

## 5. View and Manage Policies

```bash
# List all policies
vault policy list

# Read policy content
vault policy read app-secrets

# Update policy (requires appropriate permissions)
vault policy write app-secrets /path/to/policy.hcl

# Delete policy (requires appropriate permissions)
vault policy delete app-secrets
```

## 6. Policy Development Tips

- Test policies in development environment first
- Use principle of least privilege
- Document policy purposes and use cases
- Regular review and audit of policies
- Use specific paths instead of broad wildcards when possible