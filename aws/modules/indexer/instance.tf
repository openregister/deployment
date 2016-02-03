resource "aws_instance" "indexer" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  count = "${var.instance_count}"
  subnet_id = "${aws_subnet.indexer.id}"
  user_data = "${var.user_data}"
  security_groups = [ "${aws_security_group.indexer.id}" ]
  iam_instance_profile = "${aws_iam_instance_profile.indexer_instance_profile.id}"

  tags = {
    Name = "${var.id}-${count.index + 1}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-indexer"
    Role = "indexer_app"
  }
}
