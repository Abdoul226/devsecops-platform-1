output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "region" {
  value = var.aws_region
}

output "tooling_instance_id" { value = module.tooling.instance_id }
output "tooling_public_ip" { value = module.tooling.public_ip }

