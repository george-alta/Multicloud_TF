output "wordpress_ip" {
  value       = aws_instance.wordpress.public_ip
  description = "The public IP address of the EC2 instance"
}

# output "acm_validation_info" {
#   value = aws_acm_certificate.ssl_cert.domain_validation_options
#   description = "The domain validation options for the ACM certificate"
# }

output "load_balancer_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "The DNS name of the load balancer"

}

output "rds_endpoint" {
  value       = aws_db_instance.wp_db_maria.address
  description = "The endpoint of the RDS instance"
}