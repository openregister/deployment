// Include modules

provider "aws" {
  region = "${var.aws_region}"
}

provider "statuscake" {
  username = "${var.statuscake_username}"
  apikey = "${var.statuscake_apikey}"
}

module "core" {
  source = "../modules/core"
  vpc_name = "${var.vpc_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  public_cidr_blocks = "${var.public_cidr_blocks}"
  bastion_user_data = "${data.template_file.user_data.rendered}"
  admin_ips = "${var.admin_ips}"
}

data "template_file" "user_data" {
  template = "${file("user-data/users.yaml")}"
}
