module "local-authority-sct_policy" {
  source = "../modules/instance_policy"
  id = "local-authority-sct"
  enabled = "${signum(lookup(var.instance_count, "local-authority-sct"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "local-authority-sct_openregister" {
  source = "../modules/instance"
  id = "local-authority-sct"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]

  instance_count = "${lookup(var.instance_count, "local-authority-sct")}"
  iam_instance_profile = "${module.local-authority-sct_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "local-authority-sct_elb" {
  source = "../modules/load_balancer"
  id = "local-authority-sct"
  enabled = "${signum(lookup(var.instance_count, "local-authority-sct"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.local-authority-sct_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}

module "local-authority-sct" {
  source = "../modules/register"
  id = "local-authority-sct"
  instance_count = "${lookup(var.instance_count, "local-authority-sct")}"

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
