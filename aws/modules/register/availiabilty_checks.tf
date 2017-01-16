resource "statuscake_test" "status_check_home" {
  count = "${var.enable_availability_checks * length(var.registers)}"
  website_name = "${var.vpc_name} - ${element(var.registers, count.index)} - home"
  website_url = "https://${element(aws_route53_record.multi.*.fqdn, count.index)}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}

resource "statuscake_test" "status_check_records" {
  count = "${var.enable_availability_checks * length(var.registers)}"
  website_name = "${var.vpc_name} - ${element(var.registers, count.index)} - home"
  website_url = "https://${element(aws_route53_record.multi.*.fqdn, count.index)}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}
