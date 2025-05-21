# 📘 Terraform VPC Setup Documentation
`VPC_wordpress_aws.tf`

## 📌 Overview

This Terraform configuration defines a basic **Virtual Private Cloud (VPC)** network in AWS. It creates a VPC with **public and private subnets across two availability zones**, attaches an **Internet Gateway** for internet access, and sets up appropriate **route tables** and **associations**. The tags identify the resources created by `LoadBalancersTeam`.

### variables

they are defined in `variables.tf`, and the values are in `terraform.tfvars` (not synced to GIT)

---

## ☁️ Provider Configuration

```hcl
provider "aws" {
  region = var.aws_region
}
```

* Defines AWS as the provider.
* The region is dynamically defined using a variable `var.aws_region`. 

---

## 🌐 VPC

```hcl
resource "aws_vpc" "wp_vpc" {
  cidr_block = "10.0.0.0/16"
  ...
}
```

* Creates a VPC with a `/16` CIDR block (`10.0.0.0/16`).
* Tags it for team identification using `LoadBalancersTeam`.

---

## 🌍 Subnets

### Public Subnets (in `ap-southeast-2a` and `ap-southeast-2b`)

```hcl
resource "aws_subnet" "public_a" { ... }
resource "aws_subnet" "public_b" { ... }
```

* CIDRs: `10.0.0.0/24` and `10.0.2.0/24`
* Set `map_public_ip_on_launch = true` to automatically assign public IPs.
* Used for resources needing direct internet access (e.g., Load Balancers).

### Private Subnets (in `ap-southeast-2a` and `ap-southeast-2b`)

```hcl
resource "aws_subnet" "private_a" { ... }
resource "aws_subnet" "private_b" { ... }
```

* CIDRs: `10.0.1.0/24` and `10.0.3.0/24`
* No public IPs assigned.
* Intended for backend services (e.g., databases, internal apps).

---

## 🌐 Internet Gateway (IGW)

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wp_vpc.id
  ...
}
```

* Enables internet access for public subnets.
* Is attached to the VPC.

---

## 🗺️ Route Tables

### Public Route Table

```hcl
resource "aws_route_table" "public_rt" { ... }
resource "aws_route" "internet_access" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```

* Routes `0.0.0.0/0` traffic (internet) through the Internet Gateway.
* Associated with both public subnets.

### Private Route Table

```hcl
resource "aws_route_table" "private_rt" { ... }
```

* Used for private subnets.
* **Currently does not have outbound internet access**, but it is ready for NAT Gateway integration (commented out).

---

## 🔗 Route Table Associations

* Associates public subnets to the public route table:

  ```hcl
  aws_route_table_association.public_a_assoc
  aws_route_table_association.public_b_assoc
  ```

* Associates private subnets to the private route table:

  ```hcl
  aws_route_table_association.private_a_assoc
  aws_route_table_association.private_b_assoc
  ```

---

## ⚠️ Optional/Commented NAT Gateway Configuration

The code includes **commented-out resources** for enabling internet access from private subnets via a **NAT Gateway**:

* `aws_eip.nat_eip` – Allocates an Elastic IP for the NAT Gateway.
* `aws_nat_gateway.nat_gw` – Creates a NAT Gateway in the public subnet.
* `aws_route.private_internet_access` – Adds a route in the private route table to use the NAT Gateway for outbound internet traffic.

> 💡 To enable internet access for private subnets, uncomment and apply these resources.

---

## 🏷️ Tagging

All resources are tagged with `LoadBalancersTeam`, aiding in cost tracking, resource grouping, and team ownership clarity.

---

## ✅ Summary

| Resource Type      | Count | Purpose                                           |
| ------------------ | ----- | ------------------------------------------------- |
| VPC                | 1     | Main network boundary                             |
| Subnets            | 4     | 2 public, 2 private across AZs                    |
| Internet Gateway   | 1     | Internet access for public subnets                |
| Route Tables       | 2     | 1 public, 1 private                               |
| Route Associations | 4     | Connect subnets to route tables                   |
| (Optional) NAT GW  | 1     | Outbound internet for private subnets (commented) |


