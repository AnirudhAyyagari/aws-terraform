variable "ENV" {
    description = "Environment var (NON_PROD|PROD)"
}

variable "deployment_environments" {
  description = "value"
  default = ["non-prod", "prod"]
}