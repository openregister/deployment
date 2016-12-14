output "elb_dns_name" {
  value = "${aws_elb.load_balancer.dns_name}"
}

output "fqdn" {
  value = "${aws_route53_record.load_balancer.fqdn}"
}
