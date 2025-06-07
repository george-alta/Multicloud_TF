## Terraform Project Structure Documentation

This project uses Terraform to deploy a scalable WordPress environment on AWS, with optional Azure DNS integration. Below is an overview of the main `.tf` files and their purposes:

---

### **VPC_wordpress_aws.tf**
Defines the AWS Virtual Private Cloud (VPC) and its networking components:
- **VPC**: Main network container.
- **Subnets**: Public and private subnets for resource segregation.
- **Internet Gateway (IGW)**: Allows internet access for public subnets.
- **Route Tables**: Routing rules for public and private subnets.

---

### **ALB.tf**
Configures the Application Load Balancer (ALB) and related resources:
- **aws_lb**: The ALB itself, distributing traffic to WordPress instances.
- **aws_lb_target_group**: Group of instances the ALB routes traffic to.
- **aws_lb_target_group_attachment**: Attaches EC2 instances to the target group.
- **aws_lb_listener**: Listens for HTTP/HTTPS traffic and forwards to target group.

---

### **certificate.tf**
Manages SSL/TLS certificates for HTTPS:
- **aws_acm_certificate**: Requests/validates an ACM certificate (optional, controlled by variable).
- **azurerm_dns_cname_record** (commented): Example for DNS validation using Azure DNS.

---

### **efs.tf**
Sets up Amazon Elastic File System (EFS) for shared storage:
- **aws_efs_file_system**: The EFS resource.
- **aws_efs_mount_target**: Mounts EFS in the VPC subnets.
- **aws_security_group**: Controls access to EFS, typically allowing only WordPress EC2 instances.

---

### **OpenVPN.tf**
Deploys an OpenVPN server for secure remote access:
- **aws_security_group**: Allows VPN and SSH traffic.
- **aws_instance**: EC2 instance running OpenVPN.
- **data "template_file"**: Injects user data for VPN setup.

---

### **variables.tf**
Defines all input variables for the project, such as:
- AWS region, VPC/subnet CIDRs, instance types, database credentials, domain names, etc.

---

### **outputs.tf**
Specifies outputs after deployment, such as:
- Public IPs, DNS names, and other useful resource identifiers.

---

### **providers.tf**
Configures the required providers:
- **AWS**: For all AWS resources.
- **AzureRM** (commented): For Azure DNS integration if needed.

---

### **user_data.sh.tpl** (in `templates/`)
A shell script template used as EC2 user data to automate:
- WordPress installation and configuration
- MariaDB setup
- EFS mounting
- phpMyAdmin installation
- Security hardening and health checks

---

### **Lambda-EFS-PY/index.py**
Python script for an AWS Lambda function to back up EFS data to S3 using the AWS CLI.

---

## Summary

This project automates the deployment of a production-ready WordPress environment on AWS, with modular files for networking, compute, storage, security, and automation. Optional integration with Azure DNS and Lambda-based EFS backup is included for advanced scenarios.