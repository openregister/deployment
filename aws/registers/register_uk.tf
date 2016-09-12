module "uk_policy" {
  source = "../modules/instance_policy"
  id = "uk"
  enabled = "${signum(lookup(var.instance_count, "uk"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "uk_openregister" {
  source = "../modules/instance"
  id = "uk"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "uk")}"
  iam_instance_profile = "${module.uk_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "uk_elb" {
  source = "../modules/load_balancer"
  id = "uk"
  enabled = "${signum(lookup(var.instance_count, "uk"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.uk_openregister.instance_ids}"
  security_group_ids = "${module.openregister.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
