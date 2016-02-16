variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_cidr_block" {}

variable "zones" {
  default = {
    "0" = "eu-west-1a"
    "1" = "eu-west-1b"
    "2" = "eu-west-1c"
  }
}

/*
 * NAT Instance
*/

variable "nat_instance_ami" {
//  default = "ami-30913f47"
  default = "ami-c0993ab3"
}

variable "nat_instance_type" {
  default = "t2.micro"
}

variable "nat_user_data" {}

variable "admin_ips" {}

/*
 * route53.tf
*/

variable "dns_zone_id" {
  default = "Z1QBBZW8ZAZIDC"
}

variable "dns_ttl" {
  default = "300"
}

variable "dns_domain" {
  default = "openregister.org"
}
