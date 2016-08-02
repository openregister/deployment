module "school-admissions-policy_policy" {
  source = "../modules/instance_policy"
  id = "school-admissions-policy"
  enabled = "${signum(lookup(var.instance_count, "school-admissions-policy"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "school-admissions-policy_presentation" {
  source = "../modules/instance"
  id = "school-admissions-policy"
  role = "presentation_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.presentation.subnet_ids}"
  security_group_ids = "${module.presentation.security_group_id}"

  instance_count = "${lookup(var.instance_count, "school-admissions-policy")}"
  iam_instance_profile = "${module.school-admissions-policy_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "school-admissions-policy_mint" {
  source = "../modules/instance"
  id = "school-admissions-policy"
  role = "mint_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.mint.subnet_ids}"
  security_group_ids = "${module.mint.security_group_id}"

  instance_count = "${signum(lookup(var.instance_count, "school-admissions-policy"))}"
  iam_instance_profile = "${module.school-admissions-policy_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "school-admissions-policy_openregister" {
  source = "../modules/instance"
  id = "school-admissions-policy"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "school-admissions-policy")}"
  iam_instance_profile = "${module.school-admissions-policy_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "school-admissions-policy_elb" {
  source = "../modules/load_balancer"
  id = "school-admissions-policy"
  enabled = "${signum(lookup(var.instance_count, "school-admissions-policy"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.school-admissions-policy_presentation.instance_ids}"
  security_group_ids = "${module.presentation.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
