module "field" {
  source = "../modules/register"
  id = "field"
  instance_count = "${lookup(var.instance_count, "field")}"

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

module "field_cdn" {
  source = "../modules/cdn"

  id = "field-temp"
  enabled = "${var.enable_cdn}"

  alias = "field-temp.register.gov.uk"
  origin = "${module.field.fqdn}"

  certificate_id = "${var.cloudfront_certificate_id}"
}
