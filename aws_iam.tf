resource "aws_iam_role" "cross_account_lambda_role" {
  name = local.lambda_functions

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
  name        = "${local.lambda_role_name}-policy"
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
          local.source_bucket_access
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
          local.destination_bucket_access
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cross_account_lambda_policy_attach" {
  name       = "${local.lambda_role_name}-policy-attachment"
  policy_arn = aws_iam_policy.cross_account_lambda_policy.arn
  roles      = [aws_iam_role.cross_account_lambda_role.name]
}