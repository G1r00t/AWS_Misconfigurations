# Bucket with READ permissions to all AWS users via ACL (misconfigured)
resource "aws_s3_bucket" "bucket_with_read_acl" {
  bucket = "bucket-with-read-acl-for-all"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket_with_read_acl.id
  
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "public_read_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  
  bucket = aws_s3_bucket.bucket_with_read_acl.id
  # Misconfiguration: Granting public read access
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "read_acl_public_access" {
  bucket = aws_s3_bucket.bucket_with_read_acl.id
  
  # Allowing the public ACL to take effect
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
