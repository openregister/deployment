module "datatype_policy" {
  source = "../modules/instance_policy"
  id = "datatype"
  enabled = "${signum(lookup(var.instance_count, "datatype"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "datatype_presentation" {
  source = "../modules/instance"
  id = "datatype"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "datatype")}"
  iam_instance_profile = "${module.datatype_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "datatype_mint" {
  source = "../modules/instance"
  id = "datatype"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "datatype"))}"
  iam_instance_profile = "${module.datatype_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "datatype_elb" {
  source = "../modules/load_balancer"
  id = "datatype"
  enabled = "${signum(lookup(var.instance_count, "datatype"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.datatype_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
}
