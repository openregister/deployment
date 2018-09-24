resource "aws_route53_zone" "core" {
  name = "${var.environment_name}.${var.dns_domain}"
}

resource "aws_route53_record" "zone_delegation" {
  zone_id = "${aws_route53_zone.core.zone_id}"
  name = "${var.environment_name}.${var.dns_domain}"
  type = "NS"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_route53_zone.core.name_servers}" ]
  allow_overwrite = false
}

resource "aws_route53_record" "soa" {
  zone_id = "${aws_route53_zone.core.zone_id}"
  name = "${var.environment_name}.${var.dns_domain}"
  type = "SOA"
  ttl = "900"
  records = [ "${aws_route53_zone.core.name_servers.0}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 ${var.soa_negative_cache_ttl}" ]
  allow_overwrite = false
}

resource "aws_route53_zone" "cdn" {
  count = "${var.cdn_configuration["enabled"] ? 1 : 0}"
  name = "${var.cdn_configuration["domain"]}."
}
