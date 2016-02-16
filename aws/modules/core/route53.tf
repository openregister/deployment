resource "aws_route53_record" "natgw" {
  zone_id = "${var.dns_zone_id}"
  name = "gateway.${var.vpc_name}.${var.dns_domain}"
  type = "A"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_instance.natgw.public_ip}" ]
}
