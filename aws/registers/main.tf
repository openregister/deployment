// Include modules

provider "aws" {
  region = "${var.aws_region}"
}

provider "pingdom" {
  user = "${var.pingdom_user}"
  password = "${var.pingdom_password}"
  api_key = "${var.pingdom_api_key}"
}

data "aws_ami" "ubuntu-hvm-ebs-ssd" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-zesty-17.04-amd64-server-20170412.1"]
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
  cdn_configuration = "${var.cdn_configuration}"
}

module "configuration" {
  source = "../modules/configuration"
  vpc_name = "${var.vpc_name}"
  sumologic_key = "${var.sumologic_key}"
  influxdb_configuration = "${merge(var.influxdb_configuration, map("password", var.influxdb_password))}"
}
