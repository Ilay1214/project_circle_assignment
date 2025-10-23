module "ecr" {
   for_each = toset(var.ecr_names) 

  source = "terraform-aws-modules/ecr/aws"

  repository_name = each.key

  repository_read_write_access_arns = [local.account_root_user]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType  = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}