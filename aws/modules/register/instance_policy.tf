resource "aws_iam_role" "instance_policy" {
  count = "${signum(var.instance_count)}"
  name = "${var.vpc_name}-${var.id}-role"
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

resource "aws_iam_role_policy" "iam_policy_cloudwatch_access" {
  count = "${signum(var.instance_count)}"
  name = "${format("%s_CloudWatch_PutMetricData", var.vpc_name)}"
  role = "${aws_iam_role.instance_policy.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "Stmt1456223097000",
    "Effect": "Allow",
    "Action": [
      "cloudwatch:PutMetricData"
    ],
    "Resource": [
      "*"
    ]}
  ]
}
POLICY
}

resource "aws_iam_role_policy" "policy_config_access" {
  count = "${signum(var.instance_count)}"
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
        "arn:aws:s3:::openregister.${var.vpc_name}.config/${var.id}/openregister/*",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/fields.yaml",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/registers.yaml"
      ],
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "instance_policy" {
  count = "${signum(var.instance_count)}"
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
                "arn:aws:s3:::openregister.app.artifacts/*"
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

resource "aws_iam_instance_profile" "instance_policy" {
  count = "${signum(var.instance_count)}"
  name = "${var.vpc_name}-${var.id}"
  path = "/"
  roles = [ "${aws_iam_role.instance_policy.name}" ]
}
