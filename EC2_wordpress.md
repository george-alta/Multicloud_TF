

# 🚀 Terraform EC2 Instance for WordPress – Documentation

This Terraform configuration provisions an **EC2 instance** to run a WordPress website. It includes:

- A WordPress-ready EC2 instance.
- A startup script using `user_data` to configure the server.
- A security group allowing HTTP, HTTPS, and SSH access.

---

## 📦 EC2 Instance Resource

```hcl
resource "aws_instance" "wordpress" {
  ami                         = "ami-06a0b33485e9d1cf1"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = "DCE04"
}
```

### ✅ Key Properties:

| Attribute                     | Description                                                             |
| ----------------------------- | ----------------------------------------------------------------------- |
| `ami`                         | Amazon Linux 2023 AMI (or custom image) for WordPress setup             |
| `instance_type`               | `t2.micro`, suitable for free tier or light workloads                   |
| `subnet_id`                   | Launches instance in the **public subnet** for internet access          |
| `associate_public_ip_address` | Ensures the instance gets a public IP                                   |
| `key_name`                    | Name of the key pair for SSH access (`DCE04`)                           |
| `vpc_security_group_ids`      | Associates a custom security group (see below)                          |
| `user_data`                   | A base64-encoded shell script used to configure the instance on startup |

---

### 📄 `user_data` Script

```hcl
user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
  db_name             = var.db_name
  db_user             = var.db_user
  db_pass             = var.db_pass
  mysql_root_password = var.mysql_root_password
}))
```

* This uses a **template file** to generate a dynamic shell script. The arguments are variables in the User data Script.
* Passes database configuration as variables. The contents of the terraform vars is in the terraform.tfvars file (not synced to GITHUB)
* Useful for automating WordPress installation, package installation, or service setup.

---

## 🔐 Security Group – `wordpress_sg`

```hcl
resource "aws_security_group" "wordpress_sg" { ... }
```

### ✅ Ingress Rules (Inbound)

| Port | Protocol | Description  | Source      |
| ---- | -------- | ------------ | ----------- |
| 80   | TCP      | HTTP access  | `0.0.0.0/0` |
| 443  | TCP      | HTTPS access | `0.0.0.0/0` |
| 22   | TCP      | SSH access   | `0.0.0.0/0` |

* Allows incoming web and remote management traffic from **anywhere**.
* ⚠️ SSH access from `0.0.0.0/0` is insecure in production — restrict it to trusted IPs.

### ✅ Egress Rule (Outbound)

| Port | Protocol | Description      | Destination |
| ---- | -------- | ---------------- | ----------- |
| All  | All      | Allow all egress | `0.0.0.0/0` |

* Ensures the EC2 instance can reach out to the internet (e.g., for updates or package installs).

---

## 🏷️ Tags

Both the EC2 instance and security group use descriptive `Name` tags for easy identification.

---

## 🧾 Summary

| Component       | Purpose                                |
| --------------- | -------------------------------------- |
| EC2 Instance    | Runs WordPress via a user\_data script |
| Security Group  | Allows web (HTTP/S) and SSH access     |
| Template Script | Configures WordPress and DB settings   |

---

> 💡 Best Practice: Limit `0.0.0.0/0` SSH access and use `aws_secretsmanager` or `SSM` for managing sensitive values.


