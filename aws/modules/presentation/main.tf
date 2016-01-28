resource "aws_subnet" "presentation" {
  vpc_id = "${var.vpc_id}"

  // Calculate subnet count from cidr_block list
  count = "${length(split(" ", var.cidr_block))}"

  cidr_block = "${element(split(" ", var.cidr_block), count.index)}"

  availability_zone = "${lookup(var.zones, count.index)}"

  tags = {
    Name = "${var.vpc_name}-presentation-app-${count.index + 1}"
    Environment = "${var.vpc_name}"
  }

}
