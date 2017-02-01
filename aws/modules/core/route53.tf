resource "aws_route53_zone" "core" {
  name = "${var.vpc_name}.${var.dns_domain}"
}

resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.core.zone_id}"
  name = "gateway.${var.vpc_name}.${var.dns_domain}"
  type = "A"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_instance.bastion.public_ip}" ]
}

resource "aws_route53_record" "zone_delegation" {
  zone_id = "${aws_route53_zone.core.zone_id}"
  name = "${var.vpc_name}.${var.dns_domain}"
  type = "NS"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_route53_zone.core.name_servers}" ]
}

resource "aws_route53_zone" "private" {
  name = "${var.vpc_name}.openregister"
  vpc_id = "${aws_vpc.registers.id}"
}
