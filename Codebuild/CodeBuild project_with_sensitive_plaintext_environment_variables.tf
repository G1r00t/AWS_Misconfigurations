# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}
# CodeBuild project with sensitive plaintext environment variables (misconfiguration)
resource "aws_codebuild_project" "example" {
  name          = "example-project-${random_string.suffix.result}"
  service_role  = aws_iam_role.codebuild.arn
  
  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    
    # Sensitive information in plaintext environment variables (misconfiguration)
    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = "AKIAIOSFODNN7EXAMPLE"
    }
    
    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    }
  }
  
  source {
    type            = "GITHUB"
    location        = "https://github.com/example/repo.git"
    git_clone_depth = 1
  }
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild" {
  name = "codebuild-role-${random_string.suffix.result}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
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