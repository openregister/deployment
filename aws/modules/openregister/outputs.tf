output "cidr_block" {
  value = "${aws_subnet.openregister.cidr_block}"
}

output "subnet_ids" {
  value = ["${aws_subnet.openregister.*.id}"]
}
