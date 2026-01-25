variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "project_name" {
  type    = string
  default = "cloud-native-devsecops"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "name_prefix" {
  type    = string
  default = "cn-ds"
}

variable "admin_principal_arn" {
  type        = string
  description = "IAM principal ARN to grant EKS cluster admin access (EKS Access Entry)."
}

