resource "aws_acm_certificate" "ssl_cert" {
  domain_name       = "yoobeeloadbalancers.xyz"
  validation_method = "DNS"

  tags = {
    Name = "SSL-Cert"
  }
  lifecycle {
    create_before_destroy = true
  }
}

