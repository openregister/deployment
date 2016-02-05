module "public_body_presentation" {
  source = "../modules/instance"
  id = "public_body"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = 1
  iam_instance_profile = "${module.public_body_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "public_body_mint" {
  source = "../modules/instance"
  id = "public_body"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = 1
  iam_instance_profile = "${module.public_body_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "public_body_elb" {
  source = "../modules/load_balancer"
  id = "public_body"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.public_body_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"
}

module "public_body_policy" {
  source = "../modules/instance_policy"
  id = "public_body"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}
