
resource "aws_iam_role_policy" "policy_indexer_app_server" {
  name = "${var.vpc_name}_RegisterAppServer"
  role = "${aws_iam_role.indexer_role.id}"
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
