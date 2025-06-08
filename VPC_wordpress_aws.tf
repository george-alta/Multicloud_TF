provider "aws" {
  region = var.aws_region
}
# provider "azurerm" {
#   features {}

#   subscription_id = var.azure_subscription_id     
#   tenant_id       = var.azure_tenant_id           
# }

# create VPC
resource "aws_vpc" "wp_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Owner = var.owner_name
    Name  = var.vpc_name
  }
}


# Create public subnet a
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.aws_availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    Owner = var.owner_name
    Name              = var.public_subnet_a_name

  }
}

# Create private subnet a
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.aws_availability_zone_a
  tags = {
    Owner = var.owner_name
    Name              = var.private_subnet_a_name
  }
}

# Create public subnet b
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.wp_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.aws_availability_zone_b
  map_public_ip_on_launch = true
  tags = {
    Owner = var.owner_name
    Name              = var.public_subnet_b_name
  }
}

# Create private subnet b
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.aws_availability_zone_b
  tags = {
    Owner = var.owner_name
    Name              = var.private_subnet_b_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    Owner = var.owner_name
    Name  = "IGW"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    Owner = var.owner_name
    Name  = "PublicRouteTable"
  }
}

# Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate route table - public_a subnet 
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate route table - public_b subnet  
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

/*
# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    LoadBalancersTeam = "Elastic_IP_NATGW"
    Name = "NAT EIP - LoadBalancersTeam"
  }
}

# NAT Gateway (must be in a public subnet)
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id  # NAT Gateway in a public subnet
  tags = {
    LoadBalancersTeam = "NATGW"
    Name = "NAT Gateway - LoadBalancersTeam"
  }

  depends_on = [aws_internet_gateway.igw]
}
*/

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    Owner = var.owner_name
    Name  = "PrivateRouteTable"
  }
}
/*
# Route for Private Subnets via NAT Gateway
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}
*/

# Associate private_a subnet with private route table
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate private_b subnet with private route table
resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}
