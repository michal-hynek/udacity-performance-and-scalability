provider "aws" {
    region = var.region
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<-EOF
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

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<-EOF
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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "attach3" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.9"

  environment {
    variables = {
      greeting = "Hello "
    }
  }

  depends_on = [
    aws_iam_role.iam_for_lambda,
    aws_cloudwatch_log_group.lambda
  ]
}