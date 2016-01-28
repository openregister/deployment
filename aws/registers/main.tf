// Include modules

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

module "core" {
  source = "../modules/core"
  vpc_name = "${var.vpc_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
  public_cidr_block = "${var.management_cidr_block}"
  nat_user_data = "${template_file.user_data.rendered}"
}

resource "template_file" "user_data" {
  template = "${file("user-data/users.yaml")}"
}
