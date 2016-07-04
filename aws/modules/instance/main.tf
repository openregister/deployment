resource "aws_instance" "instance" {
  count = "${var.instance_count}"
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(split(" ", var.subnet_ids), count.index)}"
  user_data = "${var.user_data}"
  vpc_security_group_ids = [ "${split(" ", var.security_group_ids)}" ]
  iam_instance_profile = "${var.iam_instance_profile}"

  root_block_device = {
    volume_size = "10" // gigabytes
  }

  tags = {
    // should be this once we've fixed the app startup script to use the Register tag:
    // Name = "${var.vpc_name}-${var.id}-${count.index +1}"
    Name = "${var.id}"
    Register = "${var.id}"
    Environment = "${var.vpc_name}"
    AppServer = "${var.vpc_name}-register"
    Role = "${var.role}"
    DeploymentGroup = "${var.vpc_name}-${var.role}"
  }
}
