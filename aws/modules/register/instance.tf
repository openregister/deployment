resource "aws_instance" "register" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  count = "${var.instance_count}"
  subnet_id = "${element(split(" ", var.subnet_ids), count.index)}"
  user_data = "${var.user_data}"
  security_groups = [ "${split(" ", var.security_group_ids)}" ]
  iam_instance_profile = "${aws_iam_instance_profile.register_instance_profile.id}"

  tags = {
    // should be this once we've fixed the app startup script to use the Register tag:
    // Name = "${var.vpc_name}-${var.id}-${count.index +1}"
    Name = "${var.id}"
    Register = "${var.id}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-register"
    Role = "presentation_app"
  }
}
