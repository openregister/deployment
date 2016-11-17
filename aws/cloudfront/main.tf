provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role_policy" "cloudfront_logs_lambda" {
    name = "cloudfront_logs_lambda"
    role = "${aws_iam_role.cloudfront_logs_lambda.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::cloudfront-logs-register-gov-uk/*"
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

resource "aws_iam_role" "cloudfront_logs_lambda" {
    name = "cloudfront_logs_lambda"
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

resource "aws_lambda_permission" "allow_lambda_execution_from_log_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.cloudfront_logs_to_sumologic.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::cloudfront-logs-register-gov-uk"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = "cloudfront-logs-register-gov-uk"
    lambda_function {
        lambda_function_arn = "${aws_lambda_function.cloudfront_logs_to_sumologic.arn}"
        events = ["s3:ObjectCreated:*"]
    }
}

resource "aws_lambda_function" "cloudfront_logs_to_sumologic" {
    filename = "build/lambda/cloudfront-s3-logs-to-sumologic.zip"
    function_name = "cloudfront_logs_to_sumologic"
    role = "${aws_iam_role.cloudfront_logs_lambda.arn}"
    handler = "lambda.handler"
    runtime = "nodejs"
    timeout = 20
    source_code_hash = "${base64sha256(file("build/lambda/cloudfront-s3-logs-to-sumologic.zip"))}"
}

