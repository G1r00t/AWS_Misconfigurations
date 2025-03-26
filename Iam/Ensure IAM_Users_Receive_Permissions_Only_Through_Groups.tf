provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Create an IAM user without enforced key rotation
resource "aws_iam_user" "example_user" {
  name = "example-user-no-rotation"
  path = "/"
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "example_user_key" {
  user = aws_iam_user.example_user.name
}

resource "aws_iam_user_policy" "example_policy" {
  name = "no-key-rotation-policy"
  user = aws_iam_user.example_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::example-bucket",
          "arn:aws:s3:::example-bucket/*"
        ]
      }
    ]
  })
}

# Output the access key ID (for demonstration - not recommended in production)
output "access_key_id" {
  value = aws_iam_access_key.example_user_key.id
  sensitive = true
}