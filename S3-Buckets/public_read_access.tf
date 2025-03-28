# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# 1. S3 bucket with public read access (misconfiguration)
resource "aws_s3_bucket" "public_read_bucket" {
  bucket = "public-read-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_public_access_block" "public_read_bucket_acl" {
  bucket = aws_s3_bucket.public_read_bucket.id

  # These settings allow public read access (misconfiguration)
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. Attach a bucket policy allowing public read access
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.public_read_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.public_read_bucket.arn}/*"
      }
    ]
  })
}

# 3. Set public-read ACL on the bucket (additional misconfiguration)
resource "aws_s3_bucket_acl" "public_read_acl" {
  bucket = aws_s3_bucket.public_read_bucket.id
  acl    = "public-read"
}

# Random string to make resource names unique
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
