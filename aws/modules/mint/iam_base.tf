
resource "aws_iam_role" "mint_role" {
  name = "${format("%s_%s_role", var.vpc_name, var.register)}"
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

resource "aws_iam_instance_profile" "mint_instance_profile" {
  name = "${format("%s_%s_instance_profile", var.vpc_name, var.register)}"
  path = "/"
  roles = [ "${aws_iam_role.mint_role.name}" ]
}


