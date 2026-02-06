#!/bin/bash
set -e

echo "Setting up Vault Ansible Environment"
echo "====================================="

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Create virtual environment if it doesn't exist
if [ ! -d "vault-ansible" ]; then
    echo "Creating virtual environment with uv..."
    uv venv vault-ansible
fi

# Activate virtual environment and install dependencies
echo "Activating virtual environment and installing dependencies..."
source vault-ansible/bin/activate
uv pip install -r requirements.txt

echo ""
echo "Environment setup complete!"
echo ""
echo "To activate the environment manually:"
echo "  source vault-ansible/bin/activate"
echo ""
echo "To run playbooks:"
echo "  source vault-ansible/bin/activate && ./run-playbook.sh init"
echo ""