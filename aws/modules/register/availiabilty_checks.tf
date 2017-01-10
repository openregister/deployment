resource "statuscake_test" "status_check_home" {
  website_name = "${var.vpc_name} - ${var.id} - home"
  website_url = "https://${aws_route53_record.load_balancer.fqdn}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  count = "${signum(var.enable_availability_checks * var.instance_count)}"
}

resource "statuscake_test" "status_check_records" {
  website_name = "${var.vpc_name} - ${var.id} - records"
  website_url = "https://${aws_route53_record.load_balancer.fqdn}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
  count = "${signum(var.enable_availability_checks * var.instance_count)}"
}

resource "statuscake_test" "status_check_home_multi" {
  count = "${var.enable_availability_checks * length(var.registers)}"
  website_name = "${var.vpc_name} - ${element(var.registers, count.index)} - home"
  website_url = "https://${element(aws_route53_record.multi.*.fqdn, count.index)}"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}

resource "statuscake_test" "status_check_records_multi" {
  count = "${var.enable_availability_checks * length(var.registers)}"
  website_name = "${var.vpc_name} - ${element(var.registers, count.index)} - home"
  website_url = "https://${element(aws_route53_record.multi.*.fqdn, count.index)}/records"
  test_type = "HTTP"
  check_rate = 60
  contact_id = 55280
}
