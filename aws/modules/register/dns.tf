resource "aws_route53_record" "record" {
  count = "${var.enabled ? 1 : 0}"

  name = "${var.name}"
  type = "A"
  zone_id = "${var.dns_zone_id}"

  alias {
    name = "${var.load_balancer["dns_name"]}"
    zone_id = "${var.load_balancer["zone_id"]}"
    evaluate_target_health = false // we don't have anything to fail over to at the moment
  }
}

resource "aws_route53_record" "cdn_record" {
  count = "${var.enabled && var.cdn_configuration["enabled"] ? 1 : 0}"

  name = "${var.name}.${var.cdn_configuration["domain"]}"
  type = "A"
  zone_id = "${var.cdn_dns_zone_id}"

  alias {
    name = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false // we don't have anything to fail over to at the moment
  }
}
