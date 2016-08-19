module "food-authority_policy" {
  source = "../modules/instance_policy"
  id = "food-authority"
  enabled = "${signum(lookup(var.instance_count, "food-authority"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "food-authority_openregister" {
  source = "../modules/instance"
  id = "food-authority"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "food-authority")}"
  iam_instance_profile = "${module.food-authority_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "food-authority_elb" {
  source = "../modules/load_balancer"
  id = "food-authority"
  enabled = "${signum(lookup(var.instance_count, "food-authority"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.food-authority_openregister.instance_ids}"
  security_group_ids = "${module.openregister.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}