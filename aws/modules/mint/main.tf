resource "aws_instance" "mint" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  count = "${var.instance_count}"
  subnet_id = "${aws_subnet.mint.id}"
  user_data = "${var.user_data}"
  security_groups = [ "${aws_security_group.mint.id}" ]
  iam_instance_profile = "${aws_iam_instance_profile.mint_instance_profile.id}"

  tags = {
    Name = "${var.id}-${count.index + 1}"
    Register_Name = "${var.register_name}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-mint"
  }
}
