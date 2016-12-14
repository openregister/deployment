module "local-authority-type" {
  source = "../modules/register"
  id = "local-authority-type"
  instance_count = "${lookup(var.instance_count, "local-authority-type")}"

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
