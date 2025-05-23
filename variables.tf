# all these variables values need to be present in the terraform.tfvars file
# or can be passed as command line arguments

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
variable "vpc_name" {
  type = string
}
variable "public_subnet_a_name" {
  type = string
}
variable "public_subnet_b_name" {
  type = string
}

variable "private_subnet_a_name" {
  type = string
}

variable "private_subnet_b_name" {
  type = string
}
variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "web_domain_name" {
  description = "The domain name for the WordPress site"
  type        = string
}
variable "ssl_cert_arn" {
  description = "The ARN of the SSL certificate"
  type        = string
}
variable "ec2_wordpress_key" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
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