module "job-centre_redirect" {
  source = "../modules/redirect"

  enabled = "${lookup(var.enabled_redirects, "job-centre", false)}"

  from = "job-centre.${var.environment_name}.openregister.org"
  to   = "https://jobcentre.${var.environment_name}.openregister.org"
  certificate_arn = "${var.cloudfront_certificate_arn}"
  dns_zone_id = "${module.core.dns_zone_id}"
}
