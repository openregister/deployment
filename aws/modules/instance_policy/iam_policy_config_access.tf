resource "aws_iam_role_policy" "policy_config_access" {
  count = "${var.enabled}"
  name = "${format("%sConfigAccess", var.vpc_name)}"
  role = "${aws_iam_role.instance_policy.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::openregister.${var.vpc_name}.config/${var.id}/mint/*",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/${var.id}/presentation/*",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/fields.yaml",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/registers.yaml"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}
