# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# 1. Create an S3 bucket
resource "aws_s3_bucket" "public_delete_bucket" {
  bucket = "public-delete-bucket-${random_string.suffix.result}"
}

# 2. Attach a bucket policy that allows public delete access (Misconfiguration)
resource "aws_s3_bucket_policy" "allow_public_delete" {
  bucket = aws_s3_bucket.public_delete_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicDelete"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:DeleteObject"]
        Resource  = "${aws_s3_bucket.public_delete_bucket.arn}/*"
      }
    ]
  })
}

# 3. Disable public access restrictions (Misconfiguration)
resource "aws_s3_bucket_public_access_block" "public_delete_bucket_acl" {
  bucket = aws_s3_bucket.public_delete_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Random string to make resource names unique
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
