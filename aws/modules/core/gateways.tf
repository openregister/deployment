resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.registers.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_eip" "nat_ip" { }

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat_ip.id}"
  subnet_id = "${aws_subnet.public.0.id}"

  // It's recommended to denote that the NAT Gateway depends on the Internet
  // Gateway for the VPC in which the NAT Gateway's subnet is located.
  //
  // https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
  depends_on = ["aws_internet_gateway.igw"]
}
