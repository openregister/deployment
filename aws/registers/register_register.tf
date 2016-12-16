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

  enable_availability_checks = "${var.enable_availability_checks}"
}

module "register_cdn" {
  source = "../modules/cdn"

  id = "register-temp"
  enabled = "${var.enable_cdn}"

  alias = "register-temp.register.gov.uk"
  origin = "${module.register.fqdn}"

  certificate_id = "${var.cloudfront_certificate_id}"
}
