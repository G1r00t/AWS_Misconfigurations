# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# 1. Create an RDS instance 
resource "aws_db_instance" "public_snapshot_db" {
  identifier            = "public-snapshot-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username            = "admin"
  password            = "SuperSecurePassword123!"
  publicly_accessible = true
  skip_final_snapshot  = true
}

# 2. Create an RDS snapshot
resource "aws_db_snapshot" "public_snapshot" {
  db_snapshot_identifier = "public-rds-snapshot"
  db_instance_identifier = aws_db_instance.public_snapshot_db.id
}

# 3. Make the snapshot publicly accessible (Misconfiguration)
resource "aws_db_snapshot_attributes" "public_snapshot_access" {
  db_snapshot_identifier = aws_db_snapshot.public_snapshot.id
  attribute_name         = "restore"
  values                = ["all"] 
}
