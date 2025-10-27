locals {
  project    = "project-circle-assistant" # change your project name here
  aws_region = "eu-central-1"        # change your region here
  rel_path_raw = path_relative_to_include()
  rel_path     = trim(replace(local.rel_path_raw, "\\", "/"), "/")
  environment = split(local.rel_path, "/")[0] 
  github_repo = "project_circle_assignment"   # change your github repo here
  aws_account_id = "505825010815"
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket       = "tf-state-${local.project}"
    key          = "${local.rel_path}/terraform.tfstate"
    region       = local.aws_region
    dynamodb_table = "project-circle-assistant-terraform-lock"
    encrypt      = true

  }
}

generate "provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
}
EOF
}


inputs = {
  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terragrunt"

  }
}
