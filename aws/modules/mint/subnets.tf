resource "aws_subnet" "mint" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "${var.id}"
    Environment = "${var.vpc_name}"
  }
}
