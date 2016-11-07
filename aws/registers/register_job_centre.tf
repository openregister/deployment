module "job-centre_policy" {
  source = "../modules/instance_policy"
  id = "job-centre"
  enabled = "${signum(lookup(var.instance_count, "job-centre"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "job-centre_openregister" {
  source = "../modules/instance"
  id = "job-centre"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]

  instance_count = "${lookup(var.instance_count, "job-centre")}"
  iam_instance_profile = "${module.job-centre_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "job-centre_elb" {
  source = "../modules/load_balancer"
  id = "job-centre"
  enabled = "${signum(lookup(var.instance_count, "job-centre"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.job-centre_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
