resource "aws_instance" "wordpress" {
  # best practice is to change the hardcoded ami to search for latest Amazon Linux 2023 ami
  ami                         = var.ami_aws_linux
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = var.ec2_wordpress_key
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    db_name             = var.db_name
    db_user             = var.db_user
    db_pass             = var.db_pass
    mysql_root_password = var.mysql_root_password
    efs_id              = aws_efs_file_system.wp_efs.id
  }))
  depends_on = [aws_efs_mount_target.wp_efs_mount]
  tags = {
    Name = "wordpress-ec2"
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow SSH and HTTP/S traffic"
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
    Name = "wordpress-sg"
  }
}
