module "country_presentation" {
  source = "../modules/instance"
  id = "country"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${var.register_country_presentation_instance_count}"
  iam_instance_profile = "${module.country_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "country_mint" {
  source = "../modules/instance"
  id = "country"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${var.register_country_mint_instance_count}"
  iam_instance_profile = "${module.country_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "country_elb" {
  source = "../modules/load_balancer"
  id = "country"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.country_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"

}

module "country_policy" {
  source = "../modules/instance_policy"
  id = "country"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}
