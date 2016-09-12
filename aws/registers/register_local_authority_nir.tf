module "local-authority-nir_policy" {
  source = "../modules/instance_policy"
  id = "local-authority-nir"
  enabled = "${signum(lookup(var.instance_count, "local-authority-nir"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
}

module "local-authority-nir_openregister" {
  source = "../modules/instance"
  id = "local-authority-nir"
  role = "openregister_app"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  subnet_ids = "${module.openregister.subnet_ids}"
  security_group_ids = "${module.openregister.security_group_id}"

  instance_count = "${lookup(var.instance_count, "local-authority-nir")}"
  iam_instance_profile = "${module.local-authority-nir_policy.profile_name}"

  user_data = "${data.template_file.user_data.rendered}"
}

module "local-authority-nir_elb" {
  source = "../modules/load_balancer"
  id = "local-authority-nir"
  enabled = "${signum(lookup(var.instance_count, "local-authority-nir"))}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"

  instance_ids = "${module.local-authority-nir_openregister.instance_ids}"
  security_group_ids = ["${module.openregister.security_group_id}"]
  subnet_ids = "${module.core.public_subnet_ids}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}
