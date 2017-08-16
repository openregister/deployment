resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "codepipeline" {
  name = "codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "codepipeline.amazonaws.com"
    }
  }]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "codepipeline"
  role = "${aws_iam_role.codepipeline.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Resource": "arn:aws:s3:::codepipeline*",
    "Effect": "Allow",
    "Action": "s3:PutObject"
  }, {
    "Resource": "*",
    "Effect": "Allow",
    "Action": [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "iam:PassRole",
      "lambda:InvokeFunction",
      "lambda:ListFunctions",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning"
    ]
  }]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/paas-deploy-user",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/paas-deploy-password",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/paas-deploy-aws-key",
        "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/paas-deploy-aws-secret"
      ],
      "Action": [
        "ssm:GetParameters"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${data.aws_kms_alias.paas_deploy.target_key_id}"
      ],
      "Action": [
        "kms:Decrypt"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles = ["${aws_iam_role.codebuild_role.id}"]
}
