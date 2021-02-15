provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.aws_region
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SiPage"

    workspaces {
      name = "lambda-docker-example"
    }
  }
}


data "aws_caller_identity" "this" {}
data "aws_region" "current" {}

data "aws_ecr_repository" "this" {
  name = "lambdafunctions/example"
}

locals {
  ecr_address = data.aws_ecr_repository.this.repository_url
  ecr_image   = format("%v:%v", local.ecr_address, var.lambda_version)
}


resource "aws_iam_role" "lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "example" {
  function_name = "example"
  role          = aws_iam_role.lambda.arn
  handler       = "example_lambda.lambda_handler"

  runtime = "python3.8"

  package_type = "Image"
  image_uri    = local.ecr_image

  environment {
    variables = {
      foo = "bar"
    }
  }
}
