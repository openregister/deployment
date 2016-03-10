resource "aws_iam_role" "instance_policy" {
  count = "${var.enabled}"
  name = "${var.vpc_name}-${var.id}"
  path = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "instance_policy" {
  count = "${var.enabled}"
  name = "${var.vpc_name}-${var.id}"
  path = "/"
  roles = [ "${aws_iam_role.instance_policy.name}" ]
}
