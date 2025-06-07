resource "aws_instance" "wordpress" {
  # best practice is to change the hardcoded ami to search for latest Amazon Linux 2023 ami
  ami                         = var.ami_aws_linux
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = var.ec2_wordpress_key
  iam_instance_profile        = aws_iam_instance_profile.wordpress_profile.name
  vpc_security_group_ids      = [aws_security_group.ec2_dev_sg.id]
  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    db_host             = aws_db_instance.wp_db_maria.address
    db_name             = var.rds_db_name
    db_user             = var.rds_username
    db_pass             = var.rds_password
    efs_id              = aws_efs_file_system.wp_efs.id
    wp_url              = var.wp_url
    wp_title            = var.wp_title
    wp_admin_user       = var.wp_admin_user
    wp_admin_password   = var.wp_admin_password
    wp_admin_email      = var.wp_admin_email
    mysql_root_password = var.mysql_root_password
  }))
  depends_on = [aws_efs_mount_target.wp_efs_mount, aws_db_instance.wp_db_maria]
  tags = {
    Owner       = var.owner_name
    Environment = "WordPress-DEV"
    Name        = "wordpress-ec2-dev"
  }
}

resource "aws_security_group" "ec2_dev_sg" {
  name        = "EC2-DEV-SG"
  description = "DEV SG Allow SSH and HTTP/S traffic"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
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
    Name  = "EC2-DEV-SG"
    Owner = var.owner_name

  }
}

# security group for the wordpress ec2 prod instance, allows inbound from ALB security group
resource "aws_security_group" "wordpress_prod_sg" {
  name        = "EC2-PROD-SG"
  description = "PROD SG Allow HTTP/S traffic from ALB"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }