terraform {
    source = "${get_parent_terragrunt_dir()}/../modules/eks"
}
include "root" {
    path = find_in_parent_folders()
    expose = true
}
dependencies = {
    include "iam" {
        path = "../IAM"
        expose = true
    }
    include "vpc" {
        path = "../vpc"
        expose = true
    }
    include "ecr" {
        path = "../ecr"
        expose = true
    }
}
locals {
    env = "prod"
    tags = {
     project = include.root.locals.project
     environment = local.env
     
    }
}

inputs = {
    vpc_id = include.root.locals.vpc_id
    private_subnets = include.root.locals.private_subnets
    api_public_cidrs = include.root.locals.api_public_cidrs
    eso_irsa_role_arn = include.root.locals.eso_irsa_role_arn
    environment = local.env
    project_name = local.project

    #node group settings:
    instance_types = ["t3.medium"]
    min_size = 1
    max_size = 2
    desired_size = 1
    capacity_type = "ON_DEMAND"
    ami_type = "AL2_x86_64_HVM_GP2_EBS"
}
