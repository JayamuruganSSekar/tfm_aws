provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
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

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1565891466659",
      "Action": "logs:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "archive_file" "archieve" {
  type        = "zip"
  source_file = "${path.module}/mylambda.py"
  output_path = local.lambda_zip_path
}

resource "aws_lambda_function" "validate_lambda" {
  filename      = local.lambda_zip_path
  function_name = "mylambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "mylambda.my_lambda"
  source_code_hash = filebase64sha256(local.lambda_zip_path)
  runtime = "python3.7"
}
