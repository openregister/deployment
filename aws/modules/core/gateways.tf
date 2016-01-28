resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.registers.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
    Environment = "${var.vpc_name}"
  }
}

/*
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"
}
*/
