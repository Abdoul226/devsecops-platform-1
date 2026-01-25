variable "name" { type = string }
variable "aws_region" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}

