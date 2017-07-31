module "address" {
  source = "../modules/register_group"
  id = "address"
  instance_count = "${lookup(var.group_instance_count, "address", 0)}"
  instance_type = "${lookup(var.group_instance_type, "address", "t2.large")}"
  instance_ami = "${data.aws_ami.ubuntu-hvm-ebs-ssd.image_id}"

  vpc_name = "${var.vpc_name}"
  vpc_id = "${module.core.vpc_id}"
  private_dns_zone_id = "${module.core.private_dns_zone_id}"
  subnet_ids = "${module.openregister.subnet_ids}"
  public_subnet_ids = "${module.core.public_subnet_ids}"
  user_data = "${file("templates/users.yaml")}"

  database_security_group_id = "${module.openregister_db.security_group_id}"
  bastion_security_group_id = "${module.core.bastion_security_group_id}"

  dns_zone_id = "${module.core.dns_zone_id}"
  certificate_arn = "${var.elb_certificate_arn}"
}

resource "aws_security_group_rule" "address_outbound_logit" {
  count = "${signum(lookup(var.group_instance_count, "address", 0))}"

  security_group_id = "${module.address.instance_security_group}"
  type = "egress"
  from_port = "${var.logit_tcp_ssl_port}"
  to_port = "${var.logit_tcp_ssl_port}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
