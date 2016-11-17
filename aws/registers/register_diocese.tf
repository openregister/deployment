module "diocese" {
  source = "../modules/register"
  id = "diocese"
  instance_count = "${lookup(var.instance_count, "diocese")}"

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

resource "aws_route53_record" "load_balancer" {
  count = "${signum(lookup(var.instance_count, "diocese"))}"
  zone_id = "${module.core.private_dns_zone_id}"
  name = "diocese.${var.vpc_name}.openregister.org"
  type = "CNAME"
  ttl = "300"
  records = [ "${module.diocese.elb_dns_name}" ]
}
