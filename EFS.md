# 📦 EFS Setup for WordPress on AWS

This Terraform configuration provisions an **Amazon Elastic File System (EFS)** to be used as **shared storage** for a WordPress deployment. The setup includes the EFS file system, a mount target in a private subnet, and a dedicated security group for NFS access.

---

## 📦 Resources Overview

### 1. `aws_efs_file_system.wp_efs`

Creates an **EFS file system** to store shared assets for WordPress.

| Attribute          | Value                      |
|--------------------|----------------------------|
| `creation_token`   | `wp-efs-${var.vpc_name}`   |
| `performance_mode` | `generalPurpose`           |
| `tags`             | `Name = WordPress-EFS`     |

> ✅ EFS allows WordPress instances in private subnets to share files like uploads or cache.

---

### 2. `aws_efs_mount_target.wp_efs_mount`

Creates a **mount target** for the EFS in a **private subnet** (`private_a`), enabling EC2 instances in that subnet to mount the file system.

| Attribute       | Value                         |
|------------------|-------------------------------|
| `file_system_id`| `wp_efs.id`                   |
| `subnet_id`     | `private_a.id`                |
| `security_groups` | `wp_efs_sg.id`              |

> ℹ️ If using multiple AZs, consider creating one mount target **per AZ** for high availability.

---

### 3. `aws_security_group.wp_efs_sg`

Defines the **EFS security group**, allowing **NFS (TCP 2049)** access from WordPress EC2 instances.

#### Ingress Rules:
| From | Port  | Protocol | Description             |
|------|-------|----------|-------------------------|
| `wordpress_sg` | `2049` | `tcp`     | Allow NFS from WordPress |

#### Egress Rules:
| To             | Port Range | Protocol | Description       |
|----------------|------------|----------|-------------------|
| VPC CIDR (`var.vpc_cidr`) | All        | All      | Allow outbound within VPC |

---

## 📌 Required Variables

| Variable     | Description                     |
|--------------|---------------------------------|
| `vpc_name`   | Used for the EFS creation token |
| `vpc_cidr`   | Used in security group egress   |

---

## 🛠 Usage Example in EC2 User Data

Once the EFS is deployed, mount it on your EC2 instance:

```bash
sudo mkdir -p /var/www/html
sudo yum install -y amazon-efs-utils
sudo mount -t efs -o tls ${efs_id}:/ /var/www/html
