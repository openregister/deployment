resource "aws_iam_role_policy" "policy_config_access" {
  name = "${format("%s_ConfigAccess", var.vpc_name)}"
  role = "${aws_iam_role.indexer.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::openregister.${var.vpc_name}.config/indexer/indexer.properties"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}
