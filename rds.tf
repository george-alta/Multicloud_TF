
resource "aws_db_subnet_group" "wp_db_subnet_group" {
  name       = "wp-db-subnet-group"
  subnet_ids = [
    aws_subnet.Private_a.id,
    aws_subnet.Private_b.id
  ]
  tags = {
    Name = "wp-db-subnet-group"
  }
}

resource "aws_security_group" "wp_db_sg" {
  name        = "wp-db-sg"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.DCE04_LB.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  tags = {
    Name = "wp-db-sg"
  }
}

resource "aws_db_instance" "wp_db_maria" {
  identifier         = "wp-db-maria"
  engine             = "mariadb"
  engine_version     = "11.4.5"
  instance_class     = "db.t4g.micro"
  allocated_storage  = 20
  storage_type       = "gp2"
  db_name            = "wordpressdb"
  username           = "admin"
  password           = "myLind0Password"
  publicly_accessible = false
  skip_final_snapshot = true
  availability_zone   = "ap-southeast-2a"

  vpc_security_group_ids = [aws_security_group.wp_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.wp_db_subnet_group.name

  tags = {
    Name = "WordPress MariaDB"
    LoadBalancersTeam = "RDS_MariaDB"
  }
}
