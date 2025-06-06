# 📘 Terraform Variables: WordPress on AWS

This document describes all the variables defined in the Terraform configuration for deploying a WordPress site on AWS. All values must be provided in a `terraform.tfvars` file or passed in as command-line arguments.

---

## 🧑‍💼 1. Ownership Metadata

| Variable       | Description                | Type   | Default |
|----------------|----------------------------|--------|---------|
| `owner_name`   | The owner of the resources | string | "George" |

---

## 🌍 2. AWS Region & Availability Zones

| Variable                   | Description                          | Type   | Default           |
|----------------------------|--------------------------------------|--------|-------------------|
| `aws_region`              | AWS region                           | string | "ap-southeast-2"  |
| `aws_availability_zone_a` | First Availability Zone              | string | "ap-southeast-2a" |
| `aws_availability_zone_b` | Second Availability Zone             | string | "ap-southeast-2b" |

---

## 🌐 3. VPC & Subnets

| Variable                  | Description                          | Type   |
|---------------------------|--------------------------------------|--------|
| `vpc_name`               | Name of the VPC                      | string |
| `vpc_cidr`               | CIDR block of the VPC                | string |
| `public_subnet_a_name`   | Name of public subnet A              | string |
| `public_subnet_a_cidr`   | CIDR block for public subnet A       | string |
| `private_subnet_a_name`  | Name of private subnet A             | string |
| `private_subnet_a_cidr`  | CIDR block for private subnet A      | string |
| `public_subnet_b_name`   | Name of public subnet B              | string |
| `public_subnet_b_cidr`   | CIDR block for public subnet B       | string |
| `private_subnet_b_name`  | Name of private subnet B             | string |
| `private_subnet_b_cidr`  | CIDR block for private subnet B      | string |

---

## 🖥️ 4. EC2 Configuration

| Variable            | Description                         | Type   | Default     |
|---------------------|-------------------------------------|--------|-------------|
| `ami_aws_linux`     | Amazon Linux AMI ID                 | string | ami-06a0b33485e9d1cf1 |
| `instance_type`     | EC2 instance type                   | string | t2.micro    |
| `ec2_wordpress_key` | Key pair name for the EC2 instance  | string | —           |

---

## 🗃️ 5. WordPress Database (Local EC2)

| Variable              | Description                      | Type    | Sensitive |
|-----------------------|----------------------------------|---------|-----------|
| `db_name`             | Name of the WordPress DB         | string  | No        |
| `db_user`             | DB username                      | string  | No        |
| `db_pass`             | DB user password                 | string  | ✅ Yes    |
| `mysql_root_password`| MySQL root password              | string  | ✅ Yes    |

---

## 🌐 5.1 WordPress Setup

| Variable            | Description                         | Type   | Default                               |
|---------------------|-------------------------------------|--------|---------------------------------------|
| `wp_admin_email`    | Admin email for WordPress           | string | —                                     |
| `wp_admin_password` | Admin password for WordPress        | string | —                                     |
| `wp_admin_user`     | Admin username for WordPress        | string | —                                     |
| `wp_url`            | WordPress site URL                  | string | —                                     |
| `wp_title`          | WordPress site title                | string | "WordPress on AWS with Terraform"     |

---

## 🛢️ 6. RDS Configuration

| Variable        | Description                    | Type   | Sensitive |
|-----------------|--------------------------------|--------|-----------|
| `rds_db_name`   | RDS database name              | string | No        |
| `rds_username`  | RDS username                   | string | No        |
| `rds_password`  | RDS password                   | string | ✅ Yes    |

---

## 🌐 7. Load Balancer

| Variable            | Description                         | Type   |
|---------------------|-------------------------------------|--------|
| `web_domain_name`   | Domain name for WordPress           | string |

---

## 🔒 8. SSL Certificate

| Variable            | Description                                             | Type  | Default |
|---------------------|---------------------------------------------------------|-------|---------|
| `ssl_cert_creation` | Whether to create a new ACM certificate                | bool  | false   |
| `ssl_cert_arn`      | ARN of an existing certificate (if not creating new)   | string|

---

## 🔐 9. VPN Configuration

| Variable          | Description                      | Type   | Sensitive |
|-------------------|----------------------------------|--------|-----------|
| `vpn_key_name`    | VPN server EC2 key pair name     | string | No        |
| `admin_password`  | VPN admin user password          | string | ✅ Yes    |
| `user1_password`  | VPN user1 password               | string | ✅ Yes    |

---

## 💤 10. (Disabled) Azure Configuration (Commented Out)

These are defined but not currently used:

- `azure_resource_group_name`
- `azure_subscription_id`
- `azure_tenant_id`

---

## 📌 Usage

Define these in a `terraform.tfvars` file or pass them in via CLI:

```bash
terraform apply -var="db_name=wordpress" -var="db_user=wp_user" ...
