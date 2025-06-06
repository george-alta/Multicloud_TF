# 🔐 OpenVPN Server Deployment on AWS

This Terraform configuration sets up an **OpenVPN server** on AWS using an EC2 instance in a public subnet. It includes a custom user data script for VPN user creation and configures the necessary security group rules.

---

## 📦 Resources Overview

### 1. `aws_security_group.openvpn_sg`

Creates a security group to allow traffic to the OpenVPN server.

| Rule Type | Port  | Protocol | Description            | Source        |
|-----------|-------|----------|------------------------|----------------|
| Ingress   | 1194  | UDP      | OpenVPN                | `0.0.0.0/0`    |
| Ingress   | 22    | TCP      | SSH for admin access   | `0.0.0.0/0`    |
| Egress    | All   | All      | Allow all outbound     | `0.0.0.0/0`    |

> ⚠️ For production, it's recommended to restrict SSH access to trusted IPs.

---

### 2. `data.template_file.user_data`

Loads and renders a **user data script** (`user_data_vpn.tpl`) to configure VPN users during EC2 startup.

#### Inputs:
- `admin_password`: Set in `terraform.tfvars`
- `user1_password`: Set in `terraform.tfvars`

> This script typically handles user creation, OpenVPN setup, and service start.

---

### 3. `aws_instance.openvpn`

Creates the **OpenVPN EC2 instance** with the following configuration:

| Attribute                     | Value                                  |
|-------------------------------|----------------------------------------|
| AMI                          | From variable `ami_aws_linux`          |
| Instance Type                | From variable `instance_type`          |
| Subnet                       | `public_a` (AZ A)                      |
| Public IP                    | `true` (needed for client access)      |
| Security Group               | `openvpn_sg`                           |
| SSH Key                      | From variable `vpn_key_name`           |
| User Data                    | Renders `user_data_vpn.tpl` with vars  |
| Tags                         | `Name = OpenVPN-Server`                |

---

## 📌 Required Variables

The following variables must be provided via `terraform.tfvars`:

| Variable         | Description                         | Sensitive |
|------------------|-------------------------------------|-----------|
| `admin_password` | Password for the VPN admin account  | ✅ Yes    |
| `user1_password` | Password for a standard VPN user    | ✅ Yes    |
| `vpn_key_name`   | Name of the EC2 key pair            | No        |
| `ami_aws_linux`  | Amazon Linux 2023 AMI ID            | No        |
| `instance_type`  | EC2 instance type (e.g., t2.micro)  | No        |

---

