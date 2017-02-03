variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_cidr_blocks" { type = "list" }

variable "zones" {
  default = {
    "0" = "eu-west-1a"
    "1" = "eu-west-1b"
    "2" = "eu-west-1c"
  }
}

/*
 * Bastion Instance
*/

variable "bastion_instance_ami" {
  default = "ami-c51e3eb6"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_user_data" {}

variable "admin_ips" { type = "list" }

/*
 * route53.tf
*/

variable "dns_ttl" {
  default = "300"
}

variable "dns_domain" {
  default = "openregister.org"
}

variable "dns_parent_zone_id" {
  default = "Z1QBBZW8ZAZIDC"
}

variable "sumologic_key" {}
