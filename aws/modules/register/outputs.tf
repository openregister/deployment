output "instance_ids" {
  value = "${join(" ", aws_instance.register.*.id)}"
}

output "elb_dns_name" {
  value = "${aws_elb.register.dns_name}"
}
