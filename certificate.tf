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

# create record in Azure DNS
# resource "azurerm_dns_cname_record" "cert_dns_validation" {
#   name                = tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0].resource_record_name
#   zone_name           = var.web_domain_name
#   resource_group_name = var.azure_resource_group_name
#   ttl                 = 3600
#   record              = tolist(aws_acm_certificate.ssl_cert.domain_validation_options)[0].resource_record_value
# }