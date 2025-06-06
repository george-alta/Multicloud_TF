# 📘 Terraform VPC Setup Documentation
`VPC_wordpress_aws.tf`

# VPC Infrastructure for WordPress on AWS

This Terraform configuration defines a Virtual Private Cloud (VPC) and its associated resources to support a high-availability WordPress deployment on AWS. It sets up public and private subnets across two Availability Zones in the `ap-southeast-2` region, routing for internet access, and placeholders for NAT Gateway configuration.

---

## 🔧 Providers

- **AWS Provider** is configured using a variable-defined region.
- The **Azure provider** is included but commented out — useful if multi-cloud integration is planned.

---

## 📦 Resources Overview

### 1. VPC
- **Resource:** `aws_vpc.wp_vpc`
- Creates a VPC with DNS support and hostnames enabled.
- Tags include owner and VPC name.

### 2. Subnets

#### Public Subnets
- `aws_subnet.public_a` and `aws_subnet.public_b`
- Placed in different AZs (`a` and `b`)
- Public IPs are auto-assigned on instance launch
- Tagged appropriately for team or ownership

#### Private Subnets
- `aws_subnet.private_a` and `aws_subnet.private_b`
- Also placed in different AZs
- No public IPs assigned

### 3. Internet Gateway
- **Resource:** `aws_internet_gateway.igw`
- Attached to the VPC for outbound internet access

### 4. Route Tables

#### Public Route Table
- `aws_route_table.public_rt`
- Associated with public subnets `public_a` and `public_b`
- Has a route (`aws_route.internet_access`) for `0.0.0.0/0` pointing to the IGW

#### Private Route Table
- `aws_route_table.private_rt`
- Associated with private subnets `private_a` and `private_b`
- Intended for NAT gateway routing (currently commented out)

---

## 🚧 NAT Gateway (Commented Out)

- Configuration for:
  - Elastic IP: `aws_eip.nat_eip`
  - NAT Gateway: `aws_nat_gateway.nat_gw`
  - Private route via NAT: `aws_route.private_internet_access`

> These blocks are currently commented out. Uncomment them if you need private subnet instances to access the internet via NAT.

---

## 📌 Notes

- Uses variables for dynamic naming and subnet CIDRs.
- Well-structured for modular VPC setup.
- Can be extended to include additional services like load balancers, EC2, and RDS.

---

## 📁 Variables You Must Define

Ensure these variables are defined in your `terraform.tfvars` or as inputs:

```hcl
aws_region
vpc_cidr
public_subnet_a_cidr
public_subnet_b_cidr
private_subnet_a_cidr
private_subnet_b_cidr
aws_availability_zone_a
aws_availability_zone_b
vpc_name
owner_name
public_subnet_a_name
public_subnet_b_name
private_subnet_a_name
private_subnet_b_name
