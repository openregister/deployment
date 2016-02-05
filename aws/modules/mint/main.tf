resource "aws_instance" "mint" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  count = "${var.instance_count}"
  subnet_id = "${aws_subnet.mint.id}"
  user_data = "${var.user_data}"
  security_groups = [ "${aws_security_group.mint.id}" ]
  iam_instance_profile = "${aws_iam_instance_profile.mint_instance_profile.id}"

  tags = {
    // should be this once we've fixed the app startup script to use the Register tag:
    // Name = "${var.vpc_name}-${var.id}-${count.index +1}"
    Name = "${var.register}"
    Register = "${var.id}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-mint"
    Role = "mint_app"
  }
}
