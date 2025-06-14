# all these variables values need to be present in the terraform.tfvars file
# or can be passed as command line arguments

#1 Owner of the resources

variable "owner_name" {
  description = "The owner of the resources"
  type        = string
  default     = "George"
}

#2 AWS region and availability zones

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}
variable "aws_availability_zone_a" {
  type    = string
  default = "ap-southeast-2a"

}

variable "aws_availability_zone_b" {
  type    = string
  default = "ap-southeast-2b"

}

#3 VPC and subnet info

variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_a_name" {
  type = string
}
variable "public_subnet_a_cidr" {
  type = string
}

variable "private_subnet_a_name" {
  type = string
}
variable "private_subnet_a_cidr" {
  type = string
}

variable "public_subnet_b_name" {
  type = string
}
variable "public_subnet_b_cidr" {
  type = string
}

variable "private_subnet_b_name" {
  type = string
}
variable "private_subnet_b_cidr" {
  type = string
}

#4 EC2 dev info

variable "ami_aws_linux" {
  description = "The AMI ID for the AWS Linux instance"
  type        = string
  default     = "ami-06a0b33485e9d1cf1" # current Amazon Linux 2023 AMI in ap-southeast-2

}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro" # for free tier usage
}

variable "ec2_wordpress_key" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}

#5 EC2 local database configuration 

variable "db_name" {
  description = "The name of the WordPress database"
  type        = string
}
variable "db_user" {
  description = "value of the database user"
  type        = string
}
variable "db_pass" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}
variable "mysql_root_password" {
  type      = string
  sensitive = true
}

#5.1 Wordpress Configuration
variable "wp_admin_email" {
  description = "The email address for the WordPress admin user"
  type        = string
}
variable "wp_admin_password" {
  description = "The password for the WordPress admin user"
  type        = string
}
variable "wp_admin_user" {
  description = "The username for the WordPress admin user"
  type        = string
}
variable "wp_url" {
  description = "The URL of the WordPress site"
  type        = string
}
variable "wp_title" {
  description = "The title of the WordPress site"
  type        = string
  default     = "WordPress on AWS with Terraform"
}

#6 RDS configuration
variable "rds_db_name" {
  description = "The name of the RDS database"
  type        = string
}
variable "rds_username" {
  description = "The username for the RDS database"
  type        = string
}
variable "rds_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

#7 Load Balancer info
variable "web_domain_name" {
  description = "The domain name for the WordPress site"
  type        = string
}

#8 SSL Certificate
variable "ssl_cert_creation" {
  description = "Flag to indicate if the SSL certificate should be created"
  type        = bool
  default     = false # Set to true to create a new certificate
}
variable "ssl_cert_arn" {
  description = "The ARN of the SSL certificate"
  type        = string
}

#9 VPN configuration
variable "vpn_key_name" {
  description = "VPN server EC2 key pair name"
  type        = string
}

variable "admin_password" {
  description = "VPN Admin user password"
  type        = string
  sensitive   = true
}

variable "user1_password" {
  description = "VPN User1 password"
  type        = string
  sensitive   = true
}





# disabling all azure resources for now
# variable "azure_resource_group_name" {
#   description = "The name of the Azure resource group"
#   type        = string
# }
# variable "azure_subscription_id" {
#   description = "The Azure subscription ID"
#   type        = string
# }
# variable "azure_tenant_id" {
#   description = "The Azure tenant ID"
#   type        = string
# }
