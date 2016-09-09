output "cidr_block" {
  value = "${aws_subnet.openregister.cidr_block}"
}

output "subnet_ids" {
  value = ["${aws_subnet.openregister.*.id}"]
}

output "security_group_id" {
  value = "${aws_security_group.openregister.id}"
}
