// Include modules

provider "aws" {
  region = "${var.aws_region}"
}

provider "statuscake" {
  username = "${var.statuscake_username}"
  apikey = "${var.statuscake_apikey}"
}

data "aws_ami" "ubuntu-hvm-ebs-ssd" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-yakkety-16.10-amd64-server-20170222"]
  }
  owners = ["099720109477"] # canonical account
}

module "core" {
  source = "../modules/core"
  vpc_name = "${var.vpc_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  public_cidr_blocks = "${var.public_cidr_blocks}"
  bastion_instance_ami = "${data.aws_ami.ubuntu-hvm-ebs-ssd.image_id}"
  bastion_user_data = "${file("templates/users.yaml")}"
  admin_ips = "${var.admin_ips}"
}

module "configuration" {
  source = "../modules/configuration"
  vpc_name = "${var.vpc_name}"
  sumologic_key = "${var.sumologic_key}"
  influxdb_configuration = "${merge(var.influxdb_configuration, map("password", var.influxdb_password))}"
}
