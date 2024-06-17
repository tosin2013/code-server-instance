#!/bin/bash
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x
export DEBIAN_FRONTEND=noninteractive

# Check if a hostname is provided
if [ -z "$1" ]; then
    echo "Please provide the name of the host to configure."
    exit 1
fi

# Define variables
ROLE_NAME="code-server-instance"
ROLE_REPO="https://github.com/tosin2013/code-server-instance.git"
INVENTORY_FILE="inventory"
PLAYBOOK_FILE="playbook.yml"

# Logging function
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Check if the hostname is already set to the provided value
CURRENT_HOSTNAME=$(hostnamectl status --static)
if [ "$CURRENT_HOSTNAME" != "$1" ]; then
    sudo hostnamectl set-hostname "$1"
    if [ $? -eq 0 ]; then
        log "Hostname has been set to $1"
    else
        log "Failed to set hostname to $1"
        exit 1
    fi
else
    log "Hostname is already set to $1"
fi

# Update and upgrade the system
log "Updating and upgrading the system"
sudo apt-get update && sudo apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
if [ $? -ne 0 ]; then
    log "Failed to update and upgrade the system"
    exit 1
fi

# Install Ansible if it is not already installed
if ! command -v ansible &> /dev/null; then
    log "Installing Ansible"
    sudo apt-get install -y ansible -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
    if [ $? -ne 0 ]; then
        log "Failed to install Ansible"
        exit 1
    fi
else
    log "Ansible is already installed"
fi

# Create Ansible roles directory if it doesn't exist
mkdir -p ~/ansible/roles

# Change to the Ansible roles directory
cd ~/ansible/roles || exit

# Clone the Ansible role repository
if [ ! -d "$ROLE_NAME" ]; then
    log "Cloning Ansible role repository"
    git clone $ROLE_REPO $ROLE_NAME
    if [ $? -ne 0 ]; then
        log "Failed to clone Ansible role repository"
        exit 1
    fi
else
    log "Ansible role repository already exists"
fi

# Create inventory file
log "Creating inventory file"
cat <<EOF > ~/ansible/$INVENTORY_FILE
[all]
localhost ansible_connection=local
EOF

# Create playbook file
log "Creating playbook file"
cat <<EOF > ~/ansible/$PLAYBOOK_FILE
---
- hosts: all
  become: yes

  roles:
    - $ROLE_NAME
EOF

# Change to the Ansible directory
cd ~/ansible || exit

# Run the playbook
log "Running the Ansible playbook"
ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE
if [ $? -ne 0 ]; then
    log "Failed to run Ansible playbook"
    exit 1
fi

log "Ansible role $ROLE_NAME has been configured and executed successfully."
