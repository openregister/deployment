resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.registers.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
    Environment = "${var.vpc_name}"
  }
}
