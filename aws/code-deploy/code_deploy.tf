resource "aws_iam_role" "code_deploy_role" {
  name = "code_deploy_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.eu-west-1.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code_deploy_role_policy" {
  name = "code_deploy_role_policy"
  role = "${aws_iam_role.code_deploy_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:DeleteLifecycleHook",
            "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLifecycleHooks",
                "autoscaling:PutLifecycleHook",
                "autoscaling:RecordLifecycleActionHeartbeat",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "tag:GetTags",
            "tag:GetResources"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_codedeploy_app" "presentation_deployment_application" {
  name = "presentation_app"
}

resource "aws_codedeploy_app" "mint_deployment_application" {
  name = "mint_app"
}

resource "aws_codedeploy_app" "indexer_deployment_application" {
  name = "indexer_app"
}

module "presentation_app_codedeploy_group" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "presentation_app"
  codedeploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
}

module "indexer_app_codedeploy" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "indexer_app"
  codedeploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
}

module "mint_app_codedeploy" {
  source = "../modules/codedeploy"
  code_deploy_application_name = "mint_app"
  codedeploy_role_arn = "arn:aws:iam::022990953738:role/code_deploy_role"
}
