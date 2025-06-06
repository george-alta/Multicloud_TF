# 🌐 Application Load Balancer for WordPress

This Terraform configuration provisions an **AWS Application Load Balancer (ALB)** to distribute traffic to a WordPress EC2 instance, with HTTPS support using an ACM SSL certificate. It includes a target group, listener configuration, and optional DNS integration with **Azure DNS**.

---

## 📦 Resources Overview

### 1. `aws_lb.web_alb`

Creates an **Internet-facing Application Load Balancer** across two public subnets.

| Attribute         | Value                                      |
|-------------------|--------------------------------------------|
| `name`            | `web-alb`                                  |
| `internal`        | `false` (public-facing)                    |
| `type`            | `application`                              |
| `subnets`         | `public_a`, `public_b`                     |
| `security_groups` | `wordpress_sg`                             |
| `tags`            | `Name`, `Owner`                            |

> ✅ Required for scaling and distributing secure traffic to WordPress instances.

---

### 2. `aws_lb_target_group.web_tg`

Defines the **target group** that receives traffic from the ALB.

| Attribute     | Value                    |
|---------------|--------------------------|
| `name`        | `web-tg`                 |
| `port`        | `80`                     |
| `protocol`    | `HTTP`                   |
| `vpc_id`      | From `aws_vpc.wp_vpc.id` |

---

### 3. `aws_lb_target_group_attachment.web_attach`

Attaches the **WordPress EC2 instance** to the target group.

| Attribute         | Value                     |
|-------------------|---------------------------|
| `target_id`       | `aws_instance.wordpress.id` |
| `port`            | `80`                      |
| `target_group_arn`| From `web_tg`             |

---

### 4. `aws_lb_listener.https_listener`

Creates a **listener for HTTPS (port 443)** with SSL termination using ACM.

| Attribute         | Value                             |
|-------------------|-----------------------------------|
| `port`            | `443`                             |
| `protocol`        | `HTTPS`                           |
| `ssl_policy`      | `ELBSecurityPolicy-2016-08`       |
| `certificate_arn` | `var.ssl_cert_arn` (external or ACM) |
| `default_action`  | Forward to target group (`web_tg`) |

> 🔐 Use `aws_acm_certificate.ssl_cert.arn` during initial certificate creation, then switch to `var.ssl_cert_arn` in subsequent runs.

---

### 5. 🔄 Optional: HTTP → HTTPS Redirect (Commented Out)

A **listener on port 80** that redirects HTTP traffic to HTTPS.

```hcl
resource "aws_lb_listener" "http_listener" {
  port     = 80
  protocol = "HTTP"
  ...
  redirect {
    protocol   = "HTTPS"
    port       = "443"
    status_code = "HTTP_301"
  }
}
