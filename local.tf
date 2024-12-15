locals {
  lambda_functions = {
    icargo_lambda = {
        function_name = "icargo_qual"
        handler = "icargo_lambda.handler"
        runtime = "python3.9"
        s3_bucket = " "
        s3_key = " "
        environment_variables = {

        }
        timeout = 30
        memory_size = 128
        tags = {
            environment = "production"
            project = "projectOne"
        }
    }
  }
}