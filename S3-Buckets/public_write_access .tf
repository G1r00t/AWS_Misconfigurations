# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# 1. S3 bucket with public write access (misconfiguration)
resource "aws_s3_bucket" "public_write_bucket" {
  bucket = "public-write-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_public_access_block" "public_write_bucket_acl" {
  bucket = aws_s3_bucket.public_write_bucket.id

  # These settings allow public write access (misconfiguration)
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_write" {
  bucket = aws_s3_bucket.public_write_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action    = ["s3:PutObject", "s3:PutObjectAcl"]
        Effect    = "Allow"
        Resource  = [
          "${aws_s3_bucket.public_write_bucket.arn}",
          "${aws_s3_bucket.public_write_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Random string to make resource names unique
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}