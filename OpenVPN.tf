resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-sg"
  description = "Allow OpenVPN and SSH"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    description = "Allow OpenVPN (UDP 1194)"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data_vpn.tpl")

  vars = {
    admin_password = var.admin_password
    user1_password = var.user1_password
  }
}

resource "aws_instance" "openvpn" {
  ami                         = var.ami_aws_linux
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.openvpn_sg.id]
  key_name                    = var.vpn_key_name
  user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = "OpenVPN-Server"
  }
}