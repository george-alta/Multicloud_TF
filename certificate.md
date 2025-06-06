# 🔐 SSL Certificate Setup with AWS ACM

This Terraform configuration optionally provisions an **SSL/TLS certificate** using AWS Certificate Manager (ACM) for securing the WordPress site with HTTPS. It supports DNS-based validation and is designed to integrate with **Azure DNS** for automated record creation (currently commented out).

---

## 📦 Resources Overview

### 1. `aws_acm_certificate.ssl_cert`

Creates a **public ACM certificate** for the domain specified in `var.web_domain_name`.

| Attribute         | Description                             |
|------------------|-----------------------------------------|
| `count`          | Creates the certificate only if `ssl_cert_creation` is `true` |
| `domain_name`    | From variable `web_domain_name`         |
| `validation_method` | `DNS`                                |
| `tags`           | `Name = SSL-Cert`                       |

> ℹ️ DNS validation is required — the appropriate CNAME record must be created in the DNS zone.

#### Lifecycle Protection (Optional)
The `prevent_destroy` lifecycle block is available (currently commented) to prevent accidental deletion of the certificate.

```hcl
lifecycle {
  prevent_destroy = true
}
