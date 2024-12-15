terraform {
  # Configure the AWS Provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Optionally specify a version constraint
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
