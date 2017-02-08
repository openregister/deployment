resource "statuscake_test" "home" {
  count = "${var.enabled && var.enable_availability_checks ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} - home"
  website_url = "https://${aws_route53_record.record.fqdn}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  confirmations = 1
}

resource "statuscake_test" "records" {
  count = "${var.enabled && var.enable_availability_checks ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} - records"
  website_url = "https://${aws_route53_record.record.fqdn}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  confirmations = 1
}

resource "statuscake_test" "cdn_home" {
  count = "${var.enabled && var.cdn_configuration["enabled"] && var.enable_availability_checks ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} (gov.uk) - home"
  website_url = "https://${var.name}.${var.cdn_configuration["domain"]}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  confirmations = 1
}

resource "statuscake_test" "cdn_records" {
  count = "${var.enabled && var.cdn_configuration["enabled"] && var.enable_availability_checks ? 1 : 0}"
  website_name = "${var.environment} - ${var.name} (gov.uk) - records"
  website_url = "https://${var.name}.${var.cdn_configuration["domain"]}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  confirmations = 1
}
