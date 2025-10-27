
terraform {
    source = "${get_repo_root()}/infra/modules/vpc"
}
include "root" {
    path = find_in_parent_folders()
    expose = true
}

locals {
    tags = {
    project = include.root.locals.project
    environment = include.root.locals.environment

    }
}

inputs = {
    vpc_cidr = "10.0.0.0/16"
    num_of_azs = 2
    environment = include.root.locals.environment
    project_name = include.root.locals.project
    common_tags = local.tags
}