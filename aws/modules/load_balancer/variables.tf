variable "id" {}
variable "vpc_name" {}
variable "vpc_id" {}

variable "instance_port" {
  default = "80"
}

variable "enabled" { default = 1 }

variable "subnet_ids" { type = "list" }
variable "instance_ids" { type = "list" }
variable "security_group_ids" { type = "list" }

/*
 * route53.tf
*/

variable "dns_zone_id" {}

variable "dns_ttl" {
  default = "300"
}

variable "dns_domain" {
  default = "openregister.org"
}

variable "certificate_arn" {}
