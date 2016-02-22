resource "aws_instance" "natgw" {
  ami = "${var.nat_instance_ami}"
  instance_type = "${var.nat_instance_type}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  source_dest_check = false
  security_groups = [ "${aws_security_group.natsg.id}" ]
  user_data = "${var.nat_user_data}"
  associate_public_ip_address = true

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
    Environment = "${var.vpc_name}"
    Role = "nat-gateway"
  }
}
