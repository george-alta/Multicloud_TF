
## 📘 Application Load Balancer Configuration (Terraform)

This Terraform configuration provisions an **Application Load Balancer (ALB)** in AWS to distribute incoming HTTPS traffic to a backend EC2 instance running WordPress. It includes components for the load balancer itself, a target group, a listener on port 443 (HTTPS), and target group attachment to an EC2 instance.

---

### 🔧 Resources Overview

---

### `aws_lb.web_alb`

**Purpose**: Creates the public-facing Application Load Balancer.

**Key Attributes**:

* `internal = false`: This is an internet-facing ALB.
* `load_balancer_type = "application"`: Specifies an ALB (vs. NLB).
* `subnets`: Spread across two public subnets for high availability.
* `security_groups`: Attached to a security group allowing HTTP/HTTPS.

---

### `aws_lb_target_group.web_tg`

**Purpose**: Defines the backend target group where traffic is forwarded.

**Key Attributes**:

* `port = 80`: ALB forwards traffic to port 80 of the instance.
* `protocol = "HTTP"`: Communication between ALB and EC2 is unencrypted HTTP.
* `vpc_id`: Must be in the same VPC as the EC2 instance.

---

### `aws_lb_target_group_attachment.web_attach`

**Purpose**: Attaches the EC2 instance to the target group.

**Key Attributes**:

* `target_group_arn`: Reference to the previously created target group.
* `target_id`: EC2 instance ID.
* `port = 80`: Instance listens on port 80.

---

### `aws_lb_listener.https_listener`

**Purpose**: Creates an HTTPS listener on port 443 for the ALB.

**Key Attributes**:

* `protocol = "HTTPS"`: Incoming traffic is over HTTPS.
* `port = 443`: Default HTTPS port.
* `ssl_policy`: Specifies TLS configuration.
* `certificate_arn`: Provide an existing ACM certificate or reference a newly created one.
* `default_action`: Forwards incoming requests to the target group (`web_tg`).

**Usage Notes**:

* **Initial Setup**: Use `aws_acm_certificate.ssl_cert.arn` if you're provisioning a new certificate in Terraform.
* **Subsequent Runs**: Use `var.ssl_cert_arn` to refer to an existing ACM certificate to avoid resource replacement.

---


