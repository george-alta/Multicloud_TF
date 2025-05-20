provider "aws" {
  region = "ap-southeast-2"
}

# create VPC
resource "aws_vpc" "DCE04_LB" {
  cidr_block = "10.0.0.0/16"
  tags = {
    LoadBalancersTeam = "VPC"
    Name = "VPC - LoadBalancersTeam"
  }
}

# Create public subnet a
resource "aws_subnet" "Public_a" {
  vpc_id     = aws_vpc.DCE04_LB.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    LoadBalancersTeam = "Public_SubNet_a"
    Name = "Public_Subnet_a - LoadBalancersTeam"

  }
}

# Create private subnet a
resource "aws_subnet" "Private_a" {
  vpc_id     = aws_vpc.DCE04_LB.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    LoadBalancersTeam = "Private_SubNet_a"
    Name = "Private_SubNet_a - LoadBalancersTeam"
  }
}

# Create public subnet b
resource "aws_subnet" "Public_b" {
  vpc_id     = aws_vpc.DCE04_LB.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = true
  tags = {
    LoadBalancersTeam = "Public_SubNet_b"
    Name = "Public_Subnet_b - LoadBalancersTeam"

  }
}

# Create private subnet b
resource "aws_subnet" "Private_b" {
  vpc_id     = aws_vpc.DCE04_LB.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    LoadBalancersTeam = "Private_SubNet_b"
    Name = "Private_SubNet_b - LoadBalancersTeam"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DCE04_LB.id
  tags = {
    LoadBalancersTeam = "InternetGateway"
    Name = "IGW - LoadBalancersTeam"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.DCE04_LB.id
  tags = {
    LoadBalancersTeam = "Public_route_table"
    Name = "PublicRouteTable - LoadBalancersTeam"
  }
}

# Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate route table - Public_a subnet 
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.Public_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate route table - Public_b subnet  
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.Public_b.id
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
  subnet_id     = aws_subnet.Public_a.id  # NAT Gateway in a public subnet
  tags = {
    LoadBalancersTeam = "NATGW"
    Name = "NAT Gateway - LoadBalancersTeam"
  }

  depends_on = [aws_internet_gateway.igw]
}
*/

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.DCE04_LB.id
  tags = {
    LoadBalancersTeam = "PrivateRT"
    Name = "PrivateRouteTable - LoadBalancersTeam"
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

# Associate Private_a subnet with private route table
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.Private_a.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate Private_b subnet with private route table
resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.Private_b.id
  route_table_id = aws_route_table.private_rt.id
}
