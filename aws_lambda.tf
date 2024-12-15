# aws_lambda.tf
resource "aws_lambda_function" "lambda_functions" {
  for_each = local.lambda_functions

  function_name = each.value.function_name
  handler       = each.value.handler
  runtime       = each.value.runtime
  role          = aws_iam_role.cross_account_lambda_role[each.key].arn

  s3_bucket     = each.value.s3_bucket
  s3_key        = each.value.s3_key

  environment {
    variables = each.value.environment_variables
  }

  timeout       = each.value.timeout
  memory_size   = each.value.memory_size

  tags = each.value.tags

  depends_on = [
    aws_iam_role.cross_account_lambda_role,
    aws_iam_policy.cross_account_lambda_policy
  ]
}
