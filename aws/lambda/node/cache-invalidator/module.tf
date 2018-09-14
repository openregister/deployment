provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  region = "${var.region}"
  alias  = "${var.region}"
}

data "aws_iam_role" "cache_invalidator_role" {
  role_name = "lambda-cloudfront-invalidator"
}

data "archive_file" "cache-invalidator-archive" {
  output_path = "build/node/cache-invalidator.zip"
  type = "zip"
  source_file = "node/cache-invalidator/lambda.js"
}

resource "aws_sns_topic" "cache_invalidator_cloudwatch_notifications" {
  name = "cache-invalidator-cloudwatch_notifications"
  provider         = "aws.${var.region}"
}

resource "aws_lambda_function" "cache-invalidator" {
  function_name    = "cache-invalidator"
  filename         = "build/node/cache-invalidator.zip"
  source_code_hash = "${data.archive_file.cache-invalidator-archive.output_base64sha256}"
  handler          = "lambda.handler"
  role             = "${data.aws_iam_role.cache_invalidator_role.arn}"
  memory_size      = "128"
  runtime          = "nodejs8.10"
  timeout          = "60"
  provider         = "aws.${var.region}"
}

resource "aws_cloudwatch_metric_alarm" "cache-invalidator-error" {
  alarm_name = "cache-invalidator-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = "60"
  threshold = "1"
  statistic = "Minimum"
  alarm_description = "Cache Invalidator Lambda Errors"
  dimensions = {
    FunctionName = "${aws_lambda_function.cache-invalidator.function_name}"
  }
  alarm_actions = ["${aws_sns_topic.cache_invalidator_cloudwatch_notifications.arn}"]
  provider         = "aws.${var.region}"
}
resource "aws_cloudwatch_metric_alarm" "cloudfront-post-logger-error" {
  alarm_name = "cloudfront-post-logger-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = "60"
  threshold = "1"
  statistic = "Minimum"
  alarm_description = "Cloudfront Post Logger Lambda Errors"
  dimensions = {
    FunctionName = "us-east-1.cloudfront-post-logger"
  }
  alarm_actions = ["${aws_sns_topic.cache_invalidator_cloudwatch_notifications.arn}"]
  provider         = "aws.${var.region}"
}

resource "aws_lambda_permission" "invoke-from-cloudwatch-logs" {
  statement_id  = "invoke-from-cloudwatch-logs"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cache-invalidator.arn}"
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.cloudfront-post-logger-log-group.arn}"
  provider      = "aws.${var.region}"
}

resource "aws_cloudwatch_log_group" "cloudfront-post-logger-log-group" {
  name     = "/aws/lambda/us-east-1.cloudfront-post-logger"
  provider = "aws.${var.region}"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudfront-post-logger-logs-lambda-subscription" {
  depends_on      = ["aws_lambda_permission.invoke-from-cloudwatch-logs", "aws_cloudwatch_log_group.cloudfront-post-logger-log-group"]
  name            = "cloudfront-post-logger-logs-lambda-subscription"
  provider        = "aws.${var.region}"
  log_group_name  = "/aws/lambda/us-east-1.cloudfront-post-logger"
  filter_pattern  = "loadRSF"
  destination_arn = "${aws_lambda_function.cache-invalidator.arn}"
}
