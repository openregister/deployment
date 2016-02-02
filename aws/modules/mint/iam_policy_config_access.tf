resource "aws_iam_role_policy" "policy_config_access" {
  name = "${format("%s_%s_ConfigAccess", var.vpc_name, var.register_name)}"
  role = "${aws_iam_role.mint_role.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::openregister.${var.vpc_name}.config/${var.register_name}/mint/mint-config.yaml",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/*.yaml"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}
