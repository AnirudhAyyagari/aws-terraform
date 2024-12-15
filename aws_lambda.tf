resource "aws_lambda_function" "cross_account_lambda" {
  for_each = { for name, target in local.lambdas : name => target if target.lambda_type == "crossAccount" }

  function_name = each.value.lambda_name
  runtime       = "python3.9"
  role          = aws_iam_role.cross_account_lambda_role[each.key].arn
  handler       = "lambda_function.lambda_handler"
  memory_size   = each.value.memory_size
  timeout       = each.value.timeout

  filename = "lambda_function.zip"

  environment {
    variables = each.value.environment_vars
  }

  depends_on = [
    aws_iam_policy.cross_account_lambda_policy
  ]
}
