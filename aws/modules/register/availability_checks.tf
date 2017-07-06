
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
