resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "WordPress-ALB"
    Owner = var.owner_name
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.wp_vpc.id
}

resource "aws_lb_target_group_attachment" "web_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # in first run, use the following line to create a new certificate
  # certificate_arn   = aws_acm_certificate.ssl_cert.arn
  # in subsequent runs, use the following line to use an existing certificate
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# An HTTP listener (port 80) that redirects to HTTPS
# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       host        = "#{host}"
#       path       = "/#{path}"
#       port       = "443"
#       protocol   = "HTTPS"
#       query      = "#{query}"
#       status_code = "HTTP_301"
#     }
#   }
# }

# make the load balancer point to the EC2 instance in EC2_wordpress.tf


# after creating this load balancer I need to update a DNS record in azure dns zones
# resource "azurerm_dns_cname_record" "www_alb" {
#   name                = "www"
#   zone_name           = var.web_domain_name
#   resource_group_name = var.azure_resource_group_name
#   ttl                 = 3600
#   record              = aws_lb.web_alb.dns_name
# }
#create security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG"
  description = "Allow HTTP/S traffic to ALB"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "ALB-SG"
    Owner = var.owner_name
  } 