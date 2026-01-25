locals {
  name = "${var.name_prefix}-${var.environment}"
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  aws_region = var.aws_region
  tags       = local.tags
}

module "eks" {
  source = "../../modules/eks"

  name                = local.name
  cluster_version     = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  tags                = local.tags
  admin_principal_arn = var.admin_principal_arn
}

