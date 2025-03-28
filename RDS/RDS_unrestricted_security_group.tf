# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# 1. Create an unrestricted security group (Misconfiguration)
resource "aws_security_group" "unrestricted_sg" {
  name        = "unrestricted-rds-sg"
  description = "Allows unrestricted access to RDS"

  # Allow inbound access to RDS (port 3306 for MySQL, 5432 for PostgreSQL)
  ingress {
    from_port   = 3306  # Change to 5432 for PostgreSQL, 1433 for MSSQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Anyone on the internet can access
    ipv6_cidr_blocks = ["::/0"]  # Allows public IPv6 access (worst case)
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# 2. Create an RDS instance with the unrestricted security group
resource "aws_db_instance" "public_rds" {
  identifier            = "public-rds-instance"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username            = "admin"
  password            = "SuperSecurePassword123!"
  publicly_accessible = true  # Misconfiguration: Makes it publicly reachable
  vpc_security_group_ids = [aws_security_group.unrestricted_sg.id]  # Attach unrestricted SG
  skip_final_snapshot  = true
}
