variable "id" {}
variable "vpc_name" {}
variable "vpc_id" {}

variable "cidr_blocks" { type = "list" }
variable "db_cidr_blocks" { type = "list" }

variable "public_route_table_id" {}

variable "instance_ami" {
  default = "ami-6ced7f1f"
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
