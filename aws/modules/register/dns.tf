resource "aws_route53_record" "record" {
  count = "${var.enabled ? 2 : 0}"

  name = "${var.name}"
  type = "A"
  zone_id = "${element(var.dns_zone_id, count.index)}"

  alias {
    name = "${var.load_balancer["dns_name"]}"
    zone_id = "${var.load_balancer["zone_id"]}"
    evaluate_target_health = false // we don't have anything to fail over to at the moment
  }
}
