
resource "aws_iam_role" "indexer_role" {
  name = "${format("%s-%s", var.vpc_name, var.id)}"
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

resource "aws_iam_instance_profile" "indexer_instance_profile" {
  name = "${format("%s-%s", var.vpc_name, var.id)}"
  path = "/"
  roles = [ "${aws_iam_role.indexer_role.name}" ]
}


