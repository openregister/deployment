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
  environment_name = "${var.environment_name}"
  cdn_configuration = "${var.cdn_configuration}"
}

module "configuration" {
  source = "../modules/configuration"
  environment_name = "${var.environment_name}"
  sumologic_key = "${var.sumologic_key}"
  logit_stack_id = "${var.logit_stack_id}"
  logit_tcp_ssl_port = "${var.logit_tcp_ssl_port}"
  influxdb_configuration = "${merge(var.influxdb_configuration, map("password", var.influxdb_password))}"
}
