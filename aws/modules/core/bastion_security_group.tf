resource "aws_security_group" "bastionsg" {
  name = "${var.vpc_name}-bastion-sg"
  description = "Bastion Instance Security Group"
  vpc_id = "${aws_vpc.registers.id}"
  tags = {
    Name = "${var.vpc_name}-bastion-sg"
    Environment = "${var.vpc_name}"
  }
}

// Ingress rules
resource "aws_security_group_rule" "inbound_ssh" {
  security_group_id = "${aws_security_group.bastionsg.id}"
  type = "ingress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = [ "${var.admin_ips}" ]
}

// Egress rules
resource "aws_security_group_rule" "outbound_ssh" {
  security_group_id = "${aws_security_group.bastionsg.id}"
  type = "egress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = ["${var.vpc_cidr_block}"]
}

resource "aws_security_group_rule" "outbound_dns" {
  security_group_id = "${aws_security_group.bastionsg.id}"
  type = "egress"
  from_port = "53"
  to_port = "53"
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_http" {
  security_group_id = "${aws_security_group.bastionsg.id}"
  type = "egress"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_https" {
  security_group_id = "${aws_security_group.bastionsg.id}"
  type = "egress"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
