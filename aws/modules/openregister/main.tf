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
