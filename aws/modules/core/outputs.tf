/*
 * main.tf exports
*/

// just pipelining original value so can be re-used by other modules
output "environment_name" {
  value = "${var.environment_name}"
}

/*
 * s3.tf exports
*/
output "s3_bucket_id" {
  value = "${aws_s3_bucket.register.id}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.register.arn}"
}

/*
 * route53.tf exports
*/
output "dns_zone_id" {
  value = "${aws_route53_zone.core.zone_id}"
}

// See https://www.terraform.io/upgrade-guides/0-11.html#referencing-attributes-from-resources-with-count-0
output "cdn_dns_zone_id" {
  value = "${element(concat(aws_route53_zone.cdn.*.zone_id, list("")),0)}"
}
