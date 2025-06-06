# 🗄️ RDS Configuration for WordPress on AWS

This Terraform configuration provisions a managed **MariaDB RDS instance** on AWS for use with a WordPress deployment. It includes the database instance, security group, and subnet group setup for high availability and secure access.

---

## 📦 Resources Overview

### 1. `aws_db_subnet_group.wp_db_subnet_group`

Creates a **DB Subnet Group** using two private subnets to ensure that the RDS instance is isolated from public internet access.

- **Name:** `wp-db-subnet-group`
- **Subnets:**  
  - `private_a` (AZ A)  
  - `private_b` (AZ B)
- **Tags:** `Name`, `Owner`

### 2. `aws_security_group.wp_db_sg`

Defines a **Security Group for the RDS instance** that:

- Allows **inbound MySQL (port 3306)** traffic **only** from the `wordpress_sg` (WordPress EC2 instances)
- Allows **outbound traffic** back to the same group

#### Rules:
- **Ingress:**  
  - Port: `3306`  
  - Protocol: `tcp`  
  - Source: `wordpress_sg`  
- **Egress:**  
  - All protocols  
  - Destination: `wordpress_sg`

---

### 3. `aws_db_instance.wp_db_maria`

Provisions a **MariaDB RDS instance** with the following configuration:

| Attribute                | Value                                  |
|--------------------------|----------------------------------------|
| Identifier               | `wp-db-maria`                          |
| Engine                   | `mariadb`                              |
| Version                  | `11.4.5`                               |
| Instance Type            | `db.t4g.micro`                         |
| Storage                  | `20 GB`, General Purpose SSD (`gp2`)   |
| DB Name                  | From variable `rds_db_name`            |
| Username / Password      | From variables `rds_username` / `rds_password` |
| Publicly Accessible      | `false` (private only)                 |
| Availability Zone        | `ap-southeast-2a`                      |
| VPC Security Group       | `wp_db_sg`                             |
| Subnet Group             | `wp_db_subnet_group`                   |
| Skip Final Snapshot      | `true` (for test/dev)                  |

> ℹ️ RDS is isolated in a **private subnet**, and accessible only from trusted WordPress EC2 instances via its security group.

---

## 📌 Required Variables

These variables must be defined in `terraform.tfvars` or passed in:

| Variable         | Description                      | Sensitive |
|------------------|----------------------------------|-----------|
| `rds_db_name`    | The name of the RDS database     | ❌ No     |
| `rds_username`   | Username for RDS login           | ❌ No     |
| `rds_password`   | Password for RDS login           | ✅ Yes    |
| `owner_name`     | Owner tag for all resources      | ❌ No     |

---

## ✅ Summary

This RDS setup enables a **secure and scalable MariaDB backend** for WordPress, with:
- Private networking
- Controlled security group access
- Defined subnet isolation
- Terraform variable flexibility

---

## 🚀 Next Steps

- Ensure `wordpress_sg` exists and is linked to the EC2 WordPress instance.
- Include this file in your `main.tf` or module setup.
- Validate with `terraform plan`, then `terraform apply`.

