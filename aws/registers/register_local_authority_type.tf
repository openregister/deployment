module "local-authority-type_policy" {
  source = "../modules/instance_policy"
  id = "local-authority-type"
  enabled = "${signum(lookup(var.instance_count, "local-authority-type"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "local-authority-type_presentation" {
  source = "../modules/instance"
  id = "local-authority-type"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "local-authority-type")}"
  iam_instance_profile = "${module.local-authority-type_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "local-authority-type_mint" {
  source = "../modules/instance"
  id = "local-authority-type"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "local-authority-type"))}"
  iam_instance_profile = "${module.local-authority-type_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "local-authority-type_elb" {
  source = "../modules/load_balancer"
  id = "local-authority-type"
  enabled = "${signum(lookup(var.instance_count, "local-authority-type"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.local-authority-type_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
}
