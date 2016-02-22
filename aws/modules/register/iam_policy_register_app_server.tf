resource "aws_iam_role_policy" "policy_register_app_server" {
  name = "${var.vpc_name}RegisterAppServer"
  role = "${aws_iam_role.register_role.id}"
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
                "arn:aws:s3:::presentation.app.artifacts/*",
                "arn:aws:s3:::mint.app.artifacts/*",
                "arn:aws:s3:::indexer.app.artifacts/*"
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
