output lambda_role {
    value = aws_iam_role.iam_for_lambda.arn
}

output lambda {
    value = aws_lambda_function.lambda.arn
}