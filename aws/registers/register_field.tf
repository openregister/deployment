module "field_presentation" {
  source = "../modules/instance"
  id = "field"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${var.register_field_presentation_instance_count}"
  iam_instance_profile = "${module.field_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "field_mint" {
  source = "../modules/instance"
  id = "field"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${var.register_field_mint_instance_count}"
  iam_instance_profile = "${module.field_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "field_elb" {
  source = "../modules/load_balancer"
  id = "field"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.field_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
}

module "field_policy" {
  source = "../modules/instance_policy"
  id = "field"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}
