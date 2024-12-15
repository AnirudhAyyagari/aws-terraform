locals {
  lambdas = {
    ICARGOQ = {
      lambda_name      = "test"                      # Lambda function name
      lambda_functions = "cross-account-lambda-role" # IAM role name for the Lambda function
      lambda_role_name = "test-crossaccount"         # IAM policy and attachment name
      lambda_type      = "crossAccount"              # Type of Lambda function
      memory_size      = 128                         # Memory size in MB
      timeout          = 30                          # Timeout in seconds
      environment_vars = {                           # Environment variables for the Lambda function
        ENVIRONMENT = "production"
        DEBUG       = "true"
      }
    }
  }
}
