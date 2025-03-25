#  S3 bucket with global delete permissions (misconfigured)
resource "aws_s3_bucket" "bucket_with_global_delete" {
  bucket = "bucket-with-global-delete-perms"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "global_delete_policy" {
  bucket = aws_s3_bucket.bucket_with_global_delete.id
  
  # Misconfiguration: Global Delete permission
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]
        Effect = "Allow"
        Resource = "${aws_s3_bucket.bucket_with_global_delete.arn}/*"
      }
    ]
  })
}