terraform {
    source = "${get_parent_terragrunt_dir()}/../modules/vpc"
}
include "root" {
    path   = find_in_parent_folders()
    expose = true
}

locals {
    env     = "prod"
    project = include.root.locals.project
    tags = {
     project     = include.root.locals.project
     environment = local.env
     
    }
}

inputs = {
    vpc_cidr = "10.0.0.0/16"
    num_of_azs = 3
    environment = local.env
    common_tags = local.tags
    project_name = include.root.locals.project
}
