provider "aws" {
   region  = var.aws_region
}

# Configure Cloudwatch
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambdaFunctionName}"
  retention_in_days = 7
}

# Configure output zip
data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambdaOutputPath
}

# Configure iam role
resource "aws_iam_role" "iam_lambda_role" {
  name = "iam_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_log_policy" {
  name = "lambda_log_policy"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Configure iam policy attachment
resource "aws_iam_role_policy_attachment" "lambda_log_policy" {
  role       = aws_iam_role.iam_lambda_role.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}


# Lambda function
resource "aws_lambda_function" "helloWolrdLambda" {
  function_name = var.lambdaFunctionName
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.8"
  role = aws_iam_role.iam_lambda_role.arn

  environment{
      variables = {
          greeting = "Hello World!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_log_policy, aws_cloudwatch_log_group.lambda_log_group]
}