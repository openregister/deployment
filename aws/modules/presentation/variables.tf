variable "id" {}
variable "vpc_name" {}
variable "vpc_id" {}

variable "cidr_block" {}

variable "public_route_table_id" {}

variable "instance_ami" {
  default = "ami-a10897d6"
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

variable "nat_gateway_id" {}
variable "nat_private_ip" {}
