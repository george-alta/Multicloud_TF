# create an efs put a mount target in the private subnets
resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp-efs-${var.vpc_name}"
  performance_mode = "generalPurpose"

  tags = {
    Name  = "WordPress-EFS"
    Owner = var.owner_name
  }
}

# Create EFS mount targets in private subnets
resource "aws_efs_mount_target" "wp_efs_mount_a" {
  file_system_id = aws_efs_file_system.wp_efs.id
  subnet_id      = aws_subnet.private_a.id

  security_groups = [aws_security_group.wp_efs_sg.id]
}
resource "aws_efs_mount_target" "wp_efs_mount_b" {
  file_system_id = aws_efs_file_system.wp_efs.id
  subnet_id      = aws_subnet.private_b.id

  security_groups = [aws_security_group.wp_efs_sg.id]
}

# EFS Security Group for EFS WordPress
resource "aws_security_group" "wp_efs_sg" {
  name        = "wp-efs-sg"
  description = "Allow NFS traffic to EFS"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = {
    Name  = "WordPress-EFS-SG"
    Owner = var.owner_name
  }
}