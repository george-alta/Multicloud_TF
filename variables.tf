variable "db_name" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_pass" {
  type      = string
  sensitive = true
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
  type = string
  default = "ap-southeast-2"
}