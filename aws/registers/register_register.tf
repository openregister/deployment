module "register_policy" {
  source = "../modules/instance_policy"
  id = "register"
  enabled = "${signum(lookup(var.instance_count, "register"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "register_openregister" {
  source = "../modules/instance"
  id = "register"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]

  instance_count = "${lookup(var.instance_count, "register")}"
  iam_instance_profile = "${module.register_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "register_elb" {
  source = "../modules/load_balancer"
  id = "register"
  enabled = "${signum(lookup(var.instance_count, "register"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.register_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}

module "register" {
  source = "../modules/register"
  id = "register"
  instance_count = "${lookup(var.instance_count, "register")}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"
  subnet_ids = "${module.openregister.subnet_ids}"
  public_subnet_ids = "${module.core.public_subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  user_data = "${data.template_file.user_data.rendered}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
