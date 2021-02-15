provider "aws" {
  version = "~> 3.1, != 3.14.0"

  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.aws_region
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SiPage"

    workspaces {
      name = "lambda-docker-example-services"
    }
  }
}

resource "aws_ecr_repository" "lambda" {
  for_each = toset(var.lambda_functions)
  name     = "lambdafunctions/${each.key}"
}


