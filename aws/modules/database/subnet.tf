resource "aws_subnet" "database" {
  vpc_id = "${var.vpc_id}"

  count = "${length(split(" ", var.cidr_block))}"

  cidr_block = "${element(split(" ", var.cidr_block), count.index)}"

  availability_zone = "${lookup(var.zones, count.index)}"

  tags = {
    Name = "${var.id}-db-${count.index + 1}"
    Environment = "${var.vpc_name}"
  }
}
