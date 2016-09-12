resource "aws_security_group" "db" {
  name = "${var.id}-sg"
  description = "${var.id}"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.id}-sg"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_security_group_rule" "inbound_postgres" {
  security_group_id = "${aws_security_group.db.id}"
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  cidr_blocks = "${var.allow_from}"
}
