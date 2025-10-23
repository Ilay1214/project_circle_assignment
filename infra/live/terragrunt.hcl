locals {
  project    = "project-circle-assistant" # change your project name here
  aws_region = "eu-central-1"        # change your region here
  rel_path_raw = path_relative_to_include()
  rel_path     = trim(replace(local.rel_path_raw, "\\", "/"), "/")
  environment = split(local.rel_path, "/")[0] 
  account_root_user = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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
    encrypt      = true
    use_lockfile = true
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
