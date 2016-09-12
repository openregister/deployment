module "school-tag_policy" {
  source = "../modules/instance_policy"
  id = "school-tag"
  enabled = "${signum(lookup(var.instance_count, "school-tag"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "school-tag_openregister" {
  source = "../modules/instance"
  id = "school-tag"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "school-tag")}"
  iam_instance_profile = "${module.school-tag_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "school-tag_elb" {
  source = "../modules/load_balancer"
  id = "school-tag"
  enabled = "${signum(lookup(var.instance_count, "school-tag"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.school-tag_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
