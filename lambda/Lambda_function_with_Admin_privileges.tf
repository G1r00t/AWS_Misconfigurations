# 2. Lambda function with Admin privileges (misconfigured)
resource "aws_iam_role" "lambda_admin_role" {
  name = "lambda_admin_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_admin_policy" {
  role       = aws_iam_role.lambda_admin_role.name
  # Misconfiguration: Attaching admin policy to Lambda
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "misconfigured_lambda_function"
  role          = aws_iam_role.lambda_admin_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  
  filename      = "lambda_function.zip" # You'll need to create this file
  
  environment {
    variables = {
      TEST_VAR = "test"
    }
  }
}