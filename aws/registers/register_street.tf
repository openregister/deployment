module "street_policy" {
  source = "../modules/instance_policy"
  id = "street"
  enabled = "${signum(lookup(var.instance_count, "street"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "street_openregister" {
  source = "../modules/instance"
  id = "street"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "street")}"
  iam_instance_profile = "${module.street_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "street_elb" {
  source = "../modules/load_balancer"
  id = "street"
  enabled = "${signum(lookup(var.instance_count, "street"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.street_openregister.instance_ids}"
  security_group_ids = "${module.openregister.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
