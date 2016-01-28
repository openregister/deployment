resource "aws_instance" "natgw" {
  ami = "${var.nat_instance_ami}"
  instance_type = "${var.nat_instance_type}"
  subnet_id = "${aws_subnet.public.id}"
  source_dest_check = false
  security_groups = [ "${aws_security_group.natsg.id}" ]
  user_data = "${var.nat_user_data}"

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  instance = "${aws_instance.natgw.id}"
  depends_on = [ "aws_instance.natgw" ]
}
