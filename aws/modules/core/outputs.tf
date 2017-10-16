/*
 * main.tf exports
*/

// just pipeliing original value so can be re-used by other modules
output "environment_name" {
  value = "${var.environment_name}"
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
 * route53.tf exports
*/
output "dns_zone_id" {
  value = "${aws_route53_zone.core.zone_id}"
}

output "cdn_dns_zone_id" {
  value = "${aws_route53_zone.cdn.zone_id}"
}
