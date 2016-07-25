module "town_policy" {
  source = "../modules/instance_policy"
  id = "town"
  enabled = "${signum(lookup(var.instance_count, "town"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "town_presentation" {
  source = "../modules/instance"
  id = "town"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "town")}"
  iam_instance_profile = "${module.town_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "town_mint" {
  source = "../modules/instance"
  id = "town"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "town"))}"
  iam_instance_profile = "${module.town_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "town_elb" {
  source = "../modules/load_balancer"
  id = "town"
  enabled = "${signum(lookup(var.instance_count, "town"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.town_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
