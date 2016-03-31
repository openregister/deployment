module "food-premises_policy" {
  source = "../modules/instance_policy"
  id = "food-premises"
  enabled = "${signum(lookup(var.instance_count, "food-premises"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "food-premises_presentation" {
  source = "../modules/instance"
  id = "food-premises"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "food-premises")}"
  iam_instance_profile = "${module.food-premises_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "food-premises_mint" {
  source = "../modules/instance"
  id = "food-premises"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "food-premises"))}"
  iam_instance_profile = "${module.food-premises_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "food-premises_elb" {
  source = "../modules/load_balancer"
  id = "food-premises"
  enabled = "${signum(lookup(var.instance_count, "food-premises"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.food-premises_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
}
