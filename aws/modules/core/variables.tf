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
  default = "ami-98ecb7fe"
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

variable "soa_negative_cache_ttl" {
  default = 3600
  description = "The length of time `NXDOMAIN` responses from our authoritative nameservers should be cached by recursors for"
}

