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
 * gateway.tf exports
*/
output "nat_gateway_id" {
  value = "${aws_instance.natgw.id}"
}

output "nat_private_ip" {
  value = "${aws_instance.natgw.private_ip}"
}

output "nat_public_ip" {
  value = "${aws_instance.natgw.public_ip}"
}

output "nat_fqdn_address" {
  value = "${aws_route53_record.natgw.fqdn}"
}

output "sg_natsg_id" {
  value = "${aws_security_group.natsg.id}"
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
  value = "${join(" ", aws_subnet.public.*.id)}"
}
