module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.6.1"

  name = "${var.environment}-eks-cluster"

  kubernetes_version = var.kubernetes_version

  enable_irsa                          = true
  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.api_public_cidrs
  control_plane_subnet_ids             = var.private_subnets


  create_kms_key                           = true
  kms_key_enable_default_policy            = true
  enable_cluster_creator_admin_permissions = true
  
  
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets


  eks_managed_node_groups = {
    "${var.environment}-eks-node-group" = {
      kubernetes_version = var.kubernetes_version
      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      capacity_type  = var.capacity_type
      ami_type       = var.ami_type
    }
  }
}

module "eso_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.46"

  create_role  = true
  role_name    = "${var.environment}-eso-irsa"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  role_policy_arns = [var.eso_policy_arn]


  oidc_fully_qualified_subjects = [
    "system:serviceaccount:external-secrets:external-secrets",
  ]
}

