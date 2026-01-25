variable "name" { type = string }
variable "cluster_version" { type = string }

variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "admin_principal_arn" {
  type        = string
  description = "IAM principal ARN to grant EKS cluster admin access (EKS Access Entry)."
}
