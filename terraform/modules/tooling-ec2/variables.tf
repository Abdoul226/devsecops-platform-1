variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_id" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs autorisés (si tu ouvres 8080/9000/22). Mets ton IP/32."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

