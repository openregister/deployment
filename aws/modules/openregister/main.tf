resource "aws_subnet" "openregister" {
  vpc_id = "${var.vpc_id}"

  // Calculate subnet count from cidr_block list
  count = "${length(split(" ", var.cidr_block))}"

  cidr_block = "${element(split(" ", var.cidr_block), count.index)}"

  availability_zone = "${lookup(var.zones, count.index)}"

  tags = {
    Name = "${var.vpc_name}-openregister-app-${count.index + 1}"
    Environment = "${var.vpc_name}"
  }
}

/*
resource "aws_route_table_association" "public" {
  count = "${length(split(" ", var.cidr_block))}"

  subnet_id = "${element(aws_subnet.openregister.*.id, count.index)}"
  route_table_id = "${var.public_route_table_id}"
}
*/
