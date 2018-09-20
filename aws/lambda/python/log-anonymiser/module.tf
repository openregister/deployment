resource "aws_iam_role" "lambda_s3" {
  name = "lambda_s3_role"

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

resource "aws_iam_role_policy" "s3_logs_lambda" {
  name = "lambda_s3_policy"
  role = "${aws_iam_role.lambda_s3.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::cloudfront-logs-openregister",
        "arn:aws:s3:::cloudfront-logs-register-gov-uk",
        "arn:aws:s3:::cloudfront-logs-openregister/*",
        "arn:aws:s3:::cloudfront-logs-register-gov-uk/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::cloudfront-logs-openregister-anonymised",
        "arn:aws:s3:::cloudfront-logs-register-gov-uk-anonymised",
        "arn:aws:s3:::cloudfront-logs-openregister-anonymised/*",
        "arn:aws:s3:::cloudfront-logs-register-gov-uk-anonymised/*"
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

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.log-anonymiser-register-gov-uk.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::cloudfront-logs-register-gov-uk"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "cloudfront-logs-register-gov-uk"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.log-anonymiser-register-gov-uk.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".gz"
  }
}

data "archive_file" "log-anonymiser-archive" {
  output_path = "build/python/log-anonymiser.zip"
  type = "zip"
  source_file = "python/log-anonymiser/lambda.py"
}

resource "aws_lambda_function" "log-anonymiser-register-gov-uk" {
  filename         = "build/python/log-anonymiser.zip"
  source_code_hash = "${data.archive_file.log-anonymiser-archive.output_base64sha256}"
  function_name    = "log-anonymiser-register-gov-uk"
  role             = "${aws_iam_role.lambda_s3.arn}"
  handler          = "lambda.handler"
  runtime          = "python3.6"
  timeout          = 60
  environment      = {
    variables = {
      TARGET_BUCKET = "cloudfront-logs-register-gov-uk-anonymised"
    }
  }
}

resource "aws_sns_topic" "log_anonymiser_cloudwatch_notifications" {
  name = "log_anonymiser_cloudwatch_notifications"
}

resource "aws_cloudwatch_metric_alarm" "log-anonymiser-error" {
  alarm_name = "log-anonymiser-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = "60"
  threshold = "1"
  statistic = "Minimum"
  alarm_description = "Log Anonymiser Lambda Errors"
  dimensions = {
    FunctionName = "${aws_lambda_function.log-anonymiser-register-gov-uk.function_name}"
  }
  alarm_actions = ["${aws_sns_topic.log_anonymiser_cloudwatch_notifications.arn}"]
}