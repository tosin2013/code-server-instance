#!/bin/bash

# Define variables
ROLE_NAME="code-server-instance"
ROLE_REPO="https://github.com/tosin2013/code-server-instance.git"
INVENTORY_FILE="inventory"
PLAYBOOK_FILE="playbook.yml"

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Ansible if it is not already installed
if ! command -v ansible &> /dev/null
then
    sudo apt install -y ansible
fi

# Create Ansible roles directory if it doesn't exist
mkdir -p ~/ansible/roles

# Change to the Ansible roles directory
cd ~/ansible/roles

# Clone the Ansible role repository
if [ ! -d "$ROLE_NAME" ]; then
    git clone $ROLE_REPO $ROLE_NAME
fi

# Create inventory file
cat <<EOF > ~/ansible/$INVENTORY_FILE
[all]
localhost ansible_connection=local
EOF

# Create playbook file
cat <<EOF > ~/ansible/$PLAYBOOK_FILE
---
- hosts: all
  become: yes

  roles:
    - $ROLE_NAME
EOF

# Change to the Ansible directory
cd ~/ansible

# Run the playbook
ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE

echo "Ansible role $ROLE_NAME has been configured and executed."
