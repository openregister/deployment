resource "aws_subnet" "database" {
  vpc_id = "${var.vpc_id}"

  count = "${length(var.cidr_blocks)}"

  cidr_block = "${element(var.cidr_blocks, count.index)}"

  availability_zone = "${lookup(var.zones, count.index)}"

  tags = {
    Name = "${var.id}-db-${count.index + 1}"
    Environment = "${var.vpc_name}"
  }
}
