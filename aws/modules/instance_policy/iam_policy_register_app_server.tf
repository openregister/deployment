resource "aws_iam_role_policy" "instance_policy" {
  count = "${var.enabled}"
  name = "${var.vpc_name}RegisterAppServer"
  role = "${aws_iam_role.instance_policy.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::aws-codedeploy-eu-west-1/*",
                "arn:aws:s3:::openregister.app.artifacts/*",
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY
}
