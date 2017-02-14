data "template_file" "old_user_data" {
  template = "${file("${path.module}/old-users.yaml")}"
}

resource "aws_instance" "instance" {
  count = "${var.instance_count}"
  ami = "${element(list(var.instance_ami,"ami-c51e3eb6"), count.index)}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  user_data = "${element(list(var.user_data, data.template_file.old_user_data.rendered), count.index)}"
  vpc_security_group_ids = [ "${aws_security_group.openregister.id}" ]
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
    Role = "openregister"
    DeploymentGroup = "${var.vpc_name}-openregister"
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
