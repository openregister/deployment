module "place_policy" {
  source = "../modules/instance_policy"
  id = "place"
  enabled = "${signum(lookup(var.instance_count, "place"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "place_presentation" {
  source = "../modules/instance"
  id = "place"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "place")}"
  iam_instance_profile = "${module.place_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "place_mint" {
  source = "../modules/instance"
  id = "place"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "place"))}"
  iam_instance_profile = "${module.place_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "place_elb" {
  source = "../modules/load_balancer"
  id = "place"
  enabled = "${signum(lookup(var.instance_count, "place"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.place_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
