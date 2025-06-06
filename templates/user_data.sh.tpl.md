
# 🛠️ EC2 User Data Script for WordPress Setup (`user_data.sh.tpl`)

This template file provides a **Bash startup script** used in the EC2 instance provisioning process. It automates the full setup of a **WordPress application** on **Amazon Linux 2023**, including:

- System updates
- Package installations
- EFS mounting
- WordPress download & setup
- WP-CLI configuration
- Integration with RDS and optional phpMyAdmin installation

---

## ⚙️ Script Functionality Overview

### ✅ 1. System Preparation

- Updates system packages with `dnf update -y`
- Installs required packages: Apache, PHP modules, MariaDB, and EFS utilities

### ✅ 2. Service Initialization

- Starts and enables:
  - Apache (`httpd`)
  - MariaDB server

### ✅ 3. Environment Variables (Passed from Terraform)

The following variables are injected via Terraform’s `templatefile()`:

| Variable             | Purpose                                |
|----------------------|----------------------------------------|
| `db_host`            | RDS database hostname                  |
| `db_name`            | WordPress database name                |
| `db_user`            | WordPress database user                |
| `db_pass`            | Database user password                 |
| `efs_id`             | EFS filesystem ID                      |
| `mysql_root_password`| MySQL root password (if used locally) |
| `wp_url`             | Public URL for WordPress               |
| `wp_title`           | Site title                             |
| `wp_admin_user`      | WordPress admin username               |
| `wp_admin_password`  | WordPress admin password               |
| `wp_admin_email`     | Admin email address                    |

> These variables are echoed for debugging/logging purposes.

---

### 📦 4. WordPress Setup

- Downloads and extracts the latest WordPress release
- Mounts the provided EFS volume at `/var/www/html`
- Copies WordPress files into the web root

---

### 🧰 5. WP-CLI Configuration

Uses `wp-cli` to:
- Create `wp-config.php` with DB settings
- Set WP salts and debug options
- Configure site URL and SSL admin enforcement
- Perform full WordPress installation (`wp core install`)

---

### 🔐 6. Optional Tools

- **phpMyAdmin** (optional for database management)
  - Downloaded and extracted under `/var/www/html/phpmyadmin`
- **PHP GD Library** (for image processing)

---

## 🧪 Sample Output

Upon completion, you should see:

```
✅ WordPress installed. Visit your EC2 public IP in a browser to complete setup.
```

You can access the application via the EC2’s **public IP** or **domain (if using Route53/Azure DNS)**.

---

## ✅ Best Practices

- Replace hardcoded domain with `${wp_url}` if deploying to multiple environments
- Use **IAM roles** and SSM for secure secrets management
- Monitor `/var/log/init.log` for troubleshooting bootstrap failures
- Keep `phpMyAdmin` behind a security layer if enabled in production

---

## 🗃️ File Location

This file should be stored in:

```
/templates/user\_data.sh.tpl
```

And referenced via:

```hcl
user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", { ... }))
```