module "school-type_policy" {
  source = "../modules/instance_policy"
  id = "school-type"
  enabled = "${signum(lookup(var.instance_count, "school-type"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "school-type_openregister" {
  source = "../modules/instance"
  id = "school-type"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "school-type")}"
  iam_instance_profile = "${module.school-type_policy.profile_name}"

  user_data = "${template_file.user_data.rendered}"
}

module "school-type_elb" {
  source = "../modules/load_balancer"
  id = "school-type"
  enabled = "${signum(lookup(var.instance_count, "school-type"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.school-type_openregister.instance_ids}"
  security_group_ids = "${module.openregister.security_group_id}"
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
