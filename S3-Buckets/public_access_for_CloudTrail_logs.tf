# 1. S3 bucket with public access for CloudTrail logs (misconfigured)
resource "aws_s3_bucket" "cloudtrail_logs_public" {
  bucket = "cloudtrail-logs-public-bucket"
  
  # This is explicitly misconfigured to be public
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_public_access" {
  bucket = aws_s3_bucket.cloudtrail_logs_public.id
  
  # Misconfiguration: Allowing public access
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs_public.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.cloudtrail_logs_public.arn}",
          "${aws_s3_bucket.cloudtrail_logs_public.arn}/*"
        ]
      }
    ]
  })
}