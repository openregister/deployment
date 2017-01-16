resource "aws_route53_record" "multi" {
  count = "${length(var.registers)}"
  zone_id = "${var.dns_zone_id}"
  name = "${element(var.registers, count.index)}.${var.vpc_name}.${var.dns_domain}"
  type = "A"
  alias {
    name = "${aws_elb.load_balancer.dns_name}"
    zone_id = "${aws_elb.load_balancer.zone_id}"
    evaluate_target_health = false // we don't have anything to fail over to at the moment
  }
}
