resource "aws_subnet" "indexer" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "${var.id}"
    Environment = "${var.vpc_name}"
  }
}
