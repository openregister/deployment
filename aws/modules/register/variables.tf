variable "id" {}
variable "vpc_id" {}
variable "vpc_name" {}

variable "config_bucket" {}

variable "instance_ami" {
  default = "ami-a10897d6"
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "zones" {
  default = {
    "0" = "eu-west-1a"
    "1" = "eu-west-1b"
    "2" = "eu-west-1c"
  }
}

variable "user_data" {}
variable "subnet_ids" {}

variable "security_group_ids" {}

/*
 * ELB
*/

variable "elb_instance_port" {
  default = "80"
}

variable "elb_subnet_ids" {}

/*
 *  dns.tf
 */

variable "dns_zone_id" {}

variable "dns_ttl" {
  default = "300"
}

variable "dns_domain" {
  default = "openregister.org"
}
