resource "aws_iam_role_policy" "policy_config_access" {
  name = "${format("%s_ConfigAccess", var.vpc_name)}"
  role = "${aws_iam_role.indexer_role.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::openregister.${var.vpc_name}.config/indexer/indexer.properties",
        "arn:aws:s3:::indexer.app.artifacts/*",
        "arn:aws:s3:::aws-codedeploy-eu-west-1/latest/install"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}
