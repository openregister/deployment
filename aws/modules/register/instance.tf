resource "aws_instance" "instance" {
  count = "${var.instance_count}"
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  user_data = "${var.user_data}"
  vpc_security_group_ids = [ "${var.security_group_ids}" ]
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"

  root_block_device = {
    volume_size = "10" // gigabytes
  }

  tags = {
    // should be this once we've fixed the app startup script to use the Register tag:
    // Name = "${var.vpc_name}-${var.id}-${count.index +1}"
    Name = "${var.id}"
    Register = "${var.id}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-register"
    Role = "openregister_app"
    DeploymentGroup = "${var.vpc_name}-openregister_app"
  }
}

resource "aws_route53_record" "instance_record" {
  count = "${var.instance_count}"
  zone_id = "${var.private_dns_zone_id}"
  name = "${var.id}-${count.index + 1}"
  type = "A"
  ttl = "300"
  records = [ "${element(aws_instance.instance.*.private_ip, count.index)}" ]
}
