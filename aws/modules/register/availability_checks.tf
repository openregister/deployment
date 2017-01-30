resource "statuscake_test" "home" {
  count = "${var.enable_availability_checks && var.enabled ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} - home"
  website_url = "https://${aws_route53_record.record.fqdn}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}

resource "statuscake_test" "records" {
  count = "${var.enable_availability_checks && var.enabled ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} - records"
  website_url = "https://${aws_route53_record.record.fqdn}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}
