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
        "arn:aws:s3:::openregister.${var.vpc_name}.config/registers.yaml",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/fluentd.conf",
        "arn:aws:s3:::openregister.${var.vpc_name}.config/telegraf.conf"
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
                "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "elasticloadbalancing:Describe*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:loadbalancer/${aws_elb.load_balancer.name}"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = "${signum(var.instance_count)}"
  name = "${var.vpc_name}-${var.id}-profile"
  path = "/"
  roles = [ "${aws_iam_role.instance_policy.name}" ]
}
