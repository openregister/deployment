resource "aws_instance" "natgw" {
  ami = "${var.nat_instance_ami}"
  instance_type = "${var.nat_instance_type}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  source_dest_check = false
  vpc_security_group_ids = [ "${aws_security_group.natsg.id}" ]
  user_data = "${var.nat_user_data}"
  associate_public_ip_address = true

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
    Environment = "${var.vpc_name}"
    Role = "nat-gateway"
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
