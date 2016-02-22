resource "aws_db_subnet_group" "subnet_group" {
  name = "${var.id}"
  description = "DB subnet for ${var.vpc_name}"
  subnet_ids = [ "${aws_subnet.database.*.id}" ]
  tags = {
    Name = "${var.id}"
    Environment = "${var.vpc_name}"
  }
}
