terraform {
    source = "${get_parent_terragrunt_dir()}/../modules/vpc"
}
include "root" {
    path = find_in_parent_folders()
    expose = true
}

locals {
    env ="dev"
    tags = {
     project = include.root.locals.project
     environment = local.env
     
    }
}

inputs = {
    vpc_cidr = "10.0.0.0/16"
    num_of_azs = 2
    environment = "dev"
    project_name = local.project
}