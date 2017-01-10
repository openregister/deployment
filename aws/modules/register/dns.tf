resource "aws_route53_record" "load_balancer" {
  count = "${signum(var.instance_count)}"
  zone_id = "${var.dns_zone_id}"
  name = "${var.id}.${var.vpc_name}.${var.dns_domain}"
  type = "CNAME"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_elb.load_balancer.dns_name}" ]
}

resource "aws_route53_record" "multi" {
  count = "${length(var.registers)}"
  zone_id = "${var.dns_zone_id}"
  name = "${element(var.registers, count.index)}.${var.vpc_name}.${var.dns_domain}"
  type = "CNAME"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_elb.load_balancer.dns_name}" ]
}
