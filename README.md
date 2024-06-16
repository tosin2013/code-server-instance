# Ansible Role: Nginx Proxy Manager and Code-Server

This Ansible role installs and configures Nginx Proxy Manager and code-server on an Ubuntu system. It supports both self-signed and Let's Encrypt SSL certificates.

## Requirements

- Ansible 2.9 or higher
- Ubuntu 18.04 or higher

## Role Variables

The following variables are available for configuration:

| Variable              | Default Value       | Description                                                |
|-----------------------|---------------------|------------------------------------------------------------|
| `mysql_root_password` | `strongpassword`    | The root password for MySQL.                               |
| `mysql_database`      | `npm`               | The database name for Nginx Proxy Manager.                 |
| `mysql_user`          | `npm`               | The MySQL user for Nginx Proxy Manager.                    |
| `mysql_password`      | `password`          | The password for the MySQL user.                           |
| `code_server_password`| `securepassword`    | The password for code-server.                              |
| `ssl_type`            | `self-signed`       | The type of SSL certificate to use (`letsencrypt` or `self-signed`). |
| `domain`              | `yourdomain.com`    | The domain name for SSL certificate. Required for both SSL types. |
| `email`               | `youremail@example.com` | The email for Let's Encrypt. Required if `ssl_type` is `letsencrypt`. |

## Example Playbook

```yaml
---
- hosts: all
  become: yes

  roles:
    - role: your_role_name
      vars:
        mysql_root_password: "myrootpassword"
        mysql_database: "mydatabase"
        mysql_user: "myuser"
        mysql_password: "mypassword"
        code_server_password: "mycodeserverpassword"
        ssl_type: "letsencrypt"
        domain: "mydomain.com"
        email: "myemail@example.com"
```

## Usage

1. **Clone the Repository:**
   Clone this repository to your Ansible roles directory.

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git roles/your_role_name
   ```

2. **Create Inventory and Playbook:**
   Create an inventory file and a playbook file as shown in the example.

   **Inventory File:**
   ```ini
   [all]
   localhost ansible_connection=local
   ```

   **Playbook File:**
   ```yaml
   ---
   - hosts: all
     become: yes

     roles:
       - your_role_name
   ```

3. **Run the Playbook:**
   Execute the playbook using the following command:

   ```bash
   ansible-playbook -i inventory playbook.yml
   ```

## Directory Structure

```
.
├── defaults
│   └── main.yml
├── files
│   └── docker-compose.yml
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
│   └── code-server.service.j2
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Author Information

This role was created by [Tosin Akinosho](https://github.com/tosin2013).