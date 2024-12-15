resource "aws_iam_role" "cross_account_lambda_role" {
  for_each = { for name, target in local.lambdas : name => target if target.lambda_type == "crossAccount" }

  name = each.value.lambda_functions

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cross_account_lambda_policy" {
  for_each = { for name, target in local.lambdas : name => target if target.lambda_type == "crossAccount" }

  name        = each.value.lambda_role_name
  description = "Policy for Lambda to access required resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::akl-source-bucket",
          "arn:aws:s3:::akl-source-bucket/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::dbt-docs-tracksuit-data",
          "arn:aws:s3:::dbt-docs-tracksuit-data/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cross_account_lambda_policy_attach" {
  for_each = { for name, target in local.lambdas : name => target if target.lambda_type == "crossAccount" }

  name       = each.value.lambda_role_name
  policy_arn = aws_iam_policy.cross_account_lambda_policy[each.key].arn
  roles      = [aws_iam_role.cross_account_lambda_role[each.key].name]
}
