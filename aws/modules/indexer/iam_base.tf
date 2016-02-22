resource "aws_iam_role" "indexer" {
  name = "${var.vpc_name}-indexer"
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

resource "aws_iam_instance_profile" "indexer" {
  name = "${var.vpc_name}-indexer"
  path = "/"
  roles = [ "${aws_iam_role.indexer.name}" ]
}
