variable "id" {}
variable "vpc_name" {}
variable "vpc_id" {}

variable "instance_port" {
  default = "80"
}

variable "subnet_ids" {}
variable "instance_ids" {}
variable "security_group_ids" {}

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
