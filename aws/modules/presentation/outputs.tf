output "cidr_block" {
  value = "${aws_subnet.presentation.cidr_block}"
}

output "subnet_ids" {
  value = "${join(" ", aws_subnet.presentation.*.id)}"
}

output "security_group_id" {
  value = "${aws_security_group.presentation.id}"
}
