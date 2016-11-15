module "job-centre_redirect" {
  source = "../modules/redirect"

  enabled = "${signum(lookup(var.instance_count, "job-centre"))}"

  from = "job-centre.${var.vpc_name}.openregister.org"
  to   = "https://jobcentre.${var.vpc_name}.openregister.org"
  certificate_arn = "${var.cloudfront_certificate_arn}"
  dns_zone_id = "${module.core.dns_zone_id}"
}
