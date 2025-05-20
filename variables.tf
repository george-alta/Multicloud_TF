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