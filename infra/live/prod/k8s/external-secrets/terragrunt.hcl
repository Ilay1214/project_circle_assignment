include "root" {
  path   = "${get_repo_root()}/infra/live/terragrunt.hcl"
  expose = true
}

dependency "eks" { 
  config_path = "../../eks"
  mock_outputs = {
    cluster_name                       = "mock-cluster"
    cluster_endpoint                   = "https://mock-cluster-endpoint"
    cluster_certificate_authority_data = "bW9jay1jYS1kYXRh"
    eso_irsa_role_arn                  = "arn:aws:iam::111122223333:role/mock-eso-irsa"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan","init"]
}
dependency "iam" {
    config_path = "../../iam"
    mock_outputs = {
        eso_policy_arn = "arn:aws:iam::111122223333:policy/mock-eso"
    }
    mock_outputs_allowed_terraform_commands = ["validate", "plan","init"]
}
generate "provider_k8s" {
    path = "provider_k8s.generated.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<-EOF


data "aws_eks_cluster_auth" "this" {
  name = "${dependency.eks.outputs.cluster_name}"
}

provider "kubernetes" {
  host                   = "${dependency.eks.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = "${dependency.eks.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
    token                  = data.aws_eks_cluster_auth.this.token
    load_config_file       = false
  }
}
EOF
}
terraform {
    source = "${get_repo_root()}/infra/modules/external-secrets"
}

inputs = {
    irsa_role_arn              = dependency.eks.outputs.eso_irsa_role_arn
    create_cluster_secret_store = false
    region                     = include.root.locals.aws_region
    sa_name                    = "external-secrets"
    sa_namespace               = "external-secrets"
    secret_store_name          = "aws-secrets-manager"
    mysql_ca_property          = ""
    namespaces                 = {}
}