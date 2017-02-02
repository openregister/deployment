resource "aws_security_group" "db" {
  name = "${var.id}-sg"
  description = "${var.id}"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.id}-sg"
    Environment = "${var.vpc_name}"
  }
}
