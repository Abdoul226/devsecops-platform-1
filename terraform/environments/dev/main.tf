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

module "tooling" {
  source = "../../modules/tooling-ec2"

  name             = local.name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]

  # Recommandation: laisse [] et utilise SSM (aucun port ouvert)
  allowed_ingress_cidrs = []

  tags = local.tags
}

resource "aws_security_group_rule" "tooling_to_eks_api" {
  type        = "ingress"
  description = "Allow Tooling EC2 to access EKS API (443)"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"

  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.tooling.security_group_id
}

