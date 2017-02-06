resource "aws_security_group_rule" "bastion_outbound_ssh" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${var.bastion_security_group_id}"
  type = "egress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.openregister.id}"
}

resource "aws_security_group_rule" "inbound_postgres" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${var.database_security_group_id}"
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.openregister.id}"
}

resource "aws_security_group" "openregister" {
  count = "${signum(var.instance_count)}"

  name = "${var.vpc_name}-${var.id}-openregister-sg"
  description = "Openregister EC2 Instance security group"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.vpc_name}-${var.id}-sg"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_security_group_rule" "inbound_ssh" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = "${var.bastion_security_group_id}"
}

resource "aws_security_group_rule" "inbound_http" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.load_balancer.id}"
}

resource "aws_security_group_rule" "inbound_http_application_health_check" {
  security_group_id = "${aws_security_group.openregister.id}"
  type = "ingress"
  from_port = 8081
  to_port = 8081
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.load_balancer.id}"
}

resource "aws_security_group_rule" "outbound_dns" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "egress"
  from_port = 53
  to_port = 53
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_http" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_https" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_postgres" {
  count = "${signum(var.instance_count)}"

  security_group_id = "${aws_security_group.openregister.id}"
  type = "egress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  source_security_group_id = "${var.database_security_group_id}"
}
