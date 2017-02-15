// Include modules

provider "aws" {
  region = "${var.aws_region}"
}

provider "statuscake" {
  username = "${var.statuscake_username}"
  apikey = "${var.statuscake_apikey}"
}

data "aws_ami" "ubuntu-xenial-ebs-ssd" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial*"]
  }
  owners = ["099720109477"] # canonical account
}

module "core" {
  source = "../modules/core"
  vpc_name = "${var.vpc_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  public_cidr_blocks = "${var.public_cidr_blocks}"
  bastion_user_data = "${file("templates/users.yaml")}"
  admin_ips = "${var.admin_ips}"
  sumologic_key = "${var.sumologic_key}"
}
