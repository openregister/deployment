variable "id" {}
variable "vpc_id" {}
variable "vpc_name" {}

variable "cidr_block" {}

variable "presentation_db_cidr_block" {}
variable "mint_db_cidr_block" {}

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

variable "nat_gateway_id" {}
variable "nat_private_ip" {}
