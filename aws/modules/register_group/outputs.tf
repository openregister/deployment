output "load_balancer" {
  value = {
    dns_name = "${aws_elb.load_balancer.dns_name}"
    zone_id = "${aws_elb.load_balancer.zone_id}"
  }
}
