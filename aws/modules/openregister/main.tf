resource "aws_subnet" "openregister" {
  vpc_id = "${var.vpc_id}"

  // Calculate subnet count from cidr_block list
  count = "${length(var.cidr_blocks)}"

  cidr_block = "${element(var.cidr_blocks, count.index)}"

  availability_zone = "${lookup(var.zones, count.index)}"

  tags = {
    Name = "${var.vpc_name}-openregister-app-${count.index + 1}"
    Environment = "${var.vpc_name}"
  }
}

/*
resource "aws_route_table_association" "public" {
  count = "${length(var.cidr_blocks)}"

  subnet_id = "${element(aws_subnet.openregister.*.id, count.index)}"
  route_table_id = "${var.public_route_table_id}"
}
*/
