terraform {
  required_version = "~> 0.9.0"
  backend "s3" {
    bucket  = "registers-cloudfront-terraform-state"
    key = "cloudfront.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}

resource "aws_iam_role_policy" "s3_logs_lambda" {
    name = "s3_logs_lambda"
    role = "${aws_iam_role.lambda.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::cloudfront-logs-register-gov-uk/*",
        "arn:aws:s3:::cloudtrail-logs-openregister/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda" {
    name = "lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
