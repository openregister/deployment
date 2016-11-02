resource "aws_instance" "bastion" {
  ami = "${var.bastion_instance_ami}"
  instance_type = "${var.bastion_instance_type}"
  subnet_id = "${aws_subnet.public.0.id}"
  vpc_security_group_ids = [ "${aws_security_group.bastionsg.id}" ]
  user_data = "${var.bastion_user_data}"
  associate_public_ip_address = true

  tags = {
    Name = "${var.vpc_name}-bastion"
    Environment = "${var.vpc_name}"
    Role = "bastion"
  }
}
