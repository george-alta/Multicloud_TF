# 🖥️ WordPress EC2 Instance Deployment

This Terraform configuration provisions an **Amazon EC2 instance** for hosting a WordPress site on **Amazon Linux 2023**. It uses a custom `user_data` script to install and configure WordPress, connect to RDS, and mount EFS for shared storage.

---

## 📦 Resources Overview

### 1. `aws_instance.wordpress`

Provisions the **EC2 instance** that runs WordPress.

| Attribute                     | Value                                   |
|-------------------------------|-----------------------------------------|
| AMI                          | From variable `ami_aws_linux`           |
| Instance Type                | From variable `instance_type`           |
| Subnet                       | Public Subnet A                         |
| Public IP                    | `true` (for public access)              |
| Key Pair                     | From variable `ec2_wordpress_key`       |
| Security Group               | `wordpress_sg`                          |
| User Data                    | Templated shell script with WordPress setup |
| Depends On                   | `wp_efs_mount`, `wp_db_maria`           |
| Tags                         | `Name`, `Owner`, `Environment`          |

#### 📄 `user_data.sh.tpl` receives variables:

- RDS DB connection details (`db_host`, `db_name`, etc.)
- WordPress admin setup (`wp_url`, `wp_admin_user`, etc.)
- EFS mount (`efs_id`)
- MySQL root password (`mysql_root_password`)

---

### 2. `aws_security_group.wordpress_sg`

Creates a **Security Group** to allow HTTP, HTTPS, and SSH access to the WordPress EC2 instance.

#### Ingress Rules:
| Port | Protocol | Purpose       | Source         |
|------|----------|---------------|----------------|
| 80   | TCP      | HTTP          | `0.0.0.0/0`    |
| 443  | TCP      | HTTPS         | `0.0.0.0/0`    |
| 22   | TCP      | SSH Access    | `0.0.0.0/0`    |

#### Egress Rules:
| Port | Protocol | Destination     | Purpose        |
|------|----------|------------------|----------------|
| All  | All      | `0.0.0.0/0`      | Allow outbound |

---

## 🛠 Key Features

- Automatically installs and configures WordPress using `user_data`
- Mounts **EFS** for persistent media storage
- Connects securely to **RDS MariaDB** backend
- Tagged for tracking (`Owner`, `Environment`, `Name`)

---

## 📌 Required Variables

| Variable             | Description                        |
|----------------------|------------------------------------|
| `ami_aws_linux`      | AMI ID for Amazon Linux 2023       |
| `instance_type`      | EC2 instance type (e.g. `t2.micro`)|
| `ec2_wordpress_key`  | EC2 Key pair name for SSH          |
| `wp_url`             | WordPress site URL                 |
| `wp_title`           | WordPress site title               |
| `wp_admin_user`      | Admin username                     |
| `wp_admin_password`  | Admin password                     |
| `wp_admin_email`     | Admin email                        |
| `db_name`, `db_user`, `db_pass` | DB credentials for RDS  |
| `mysql_root_password`| Root password for MySQL setup      |
| `efs_id`             | EFS file system ID                 |

---
