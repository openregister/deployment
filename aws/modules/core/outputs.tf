/*
 * main.tf exports
*/
output "vpc_id" {
  value = "${aws_vpc.registers.id}"
}

// just pipeliing original value so can be re-used by other modules
output "vpc_name" {
  value = "${var.vpc_name}"
}

/*
 * bastion.tf exports
*/
output "bastion_security_group_id" {
  value = "${aws_security_group.bastionsg.id}"
}

/*
 * s3.tf exports
*/
output "s3_bucket_id" {
  value = "${aws_s3_bucket.register.id}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.register.name}"
}

/*
 * subnets.tf exports
*/
output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

/*
 * route53.tf exports
*/
output "dns_zone_id" {
  value = "${aws_route53_zone.core.zone_id}"
}

output "private_dns_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}
