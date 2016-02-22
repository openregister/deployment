// subnets.tf exports
output "subnet_ids" {
  value = "${join(" ", aws_subnet.mint.*.id)}"
}

// security_group.tf exports
output "security_group_id" {
  value = "${aws_security_group.mint.id}"
}
