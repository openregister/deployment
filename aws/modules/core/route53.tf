resource "aws_route53_zone" "core" {
  name = "${var.vpc_name}.${var.dns_domain}"
}

resource "aws_route53_record" "natgw" {
  zone_id = "${aws_route53_zone.core.zone_id}"
  name = "gateway.${var.vpc_name}.${var.dns_domain}"
  type = "A"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_instance.natgw.public_ip}" ]
}

resource "aws_route53_record" "zone_delegation" {
  zone_id = "${var.dns_parent_zone_id}"
  name = "${var.vpc_name}.${var.dns_domain}"
  type = "NS"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_route53_zone.core.name_servers}" ]
}
