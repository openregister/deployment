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

resource "pingdom_check" "origin_records" {
  count = "${var.enabled && var.enable_availability_checks ? 1 : 0}"
  type = "http"
  name = "${var.environment} - ${var.name} (origin) - records"
  encryption = true
  host = "${aws_route53_record.record.fqdn}"
  url = "/records"
  resolution = 1
  sendtoemail = true
  sendnotificationwhendown = 2
  notifywhenbackup = true
  contactids = ["${var.pingdom_contact_ids}"]
  tags = "${var.environment},origin"
}

resource "pingdom_check" "cdn_records" {
  count = "${var.enabled && var.cdn_configuration["enabled"] && var.enable_availability_checks ? 1 : 0}"
  type = "http"
  name = "${var.environment} - ${var.name} (CDN) - records"
  encryption = true
  host = "${var.name}.${var.cdn_configuration["domain"]}"
  url = "/records"
  resolution = 1
  sendtoemail = true
  sendnotificationwhendown = 2
  notifywhenbackup = true
  contactids = ["${var.pingdom_contact_ids}"]
  tags = "${var.environment},cdn"
}
