resource "aws_security_group" "presentation" {
  name = "${var.id}-sg"
  description = "Presentation EC2 Instance security group"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.id}-sg"
    Environment = "${var.vpc_name}"
  }
}

// Ingress Rules
resource "aws_security_group_rule" "inbound_ssh" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${var.nat_private_ip}/32"]
}

resource "aws_security_group_rule" "inbound_http_from_local_subnet" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["${aws_subnet.presentation.*.cidr_block}"]
}

// Egress Rules
resource "aws_security_group_rule" "outbound_dns" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "egress"
  from_port = 53
  to_port = 53
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_http" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_https" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_postgres" {
  security_group_id = "${aws_security_group.presentation.id}"
  type = "egress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  cidr_blocks = ["${split(" ", var.db_cidr_block)}"]
}
