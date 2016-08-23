module "address_policy" {
  source = "../modules/instance_policy"
  id = "address"
  enabled = "${signum(lookup(var.instance_count, "address"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "address_presentation" {
  source = "../modules/instance"
  id = "address"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "address")}"
  instance_type = "t2.large"
  iam_instance_profile = "${module.address_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "address_mint" {
  source = "../modules/instance"
  id = "address"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "address"))}"
  iam_instance_profile = "${module.address_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "address_openregister" {
  source = "../modules/instance"
  id = "address"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "address")}"
  instance_type = "t2.large"
  iam_instance_profile = "${module.address_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "address_elb" {
  source = "../modules/load_balancer"
  id = "address"
  enabled = "${signum(lookup(var.instance_count, "address"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.address_openregister.instance_ids}"
  security_group_ids = "${module.openregister.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
