provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  region = "${var.region}"
  alias  = "${var.region}"
}

data "aws_iam_role" "cloudwatch_logs_lambda_role" {
  role_name = "lambda"
}

# data "aws_iam_role" "lambda-edge-role-test" {
#   role_name = "lambda"
# }

resource "aws_lambda_function" "cloudfront-logs-api-key-to-google-analytics" {
  function_name    = "cloudfront-logs-api-key-to-google-analytics"
  filename         = "build/node/cloudfront-logs-api-key-to-google-analytics.zip"
  source_code_hash = "${base64sha256(file("build/node/cloudfront-logs-api-key-to-google-analytics.zip"))}"
  handler          = "lambda.handler"
  role             = "${data.aws_iam_role.cloudwatch_logs_lambda_role.arn}"
  memory_size      = "128"
  runtime          = "nodejs6.10"
  timeout          = "5"
  provider         = "aws.${var.region}"

  environment {
    variables = {
      CID = "745b065b-3cef-49be-a2b1-d0f28965a958"
      TID = "UA-86101042-1"
    }
  }
}

resource "aws_lambda_permission" "invoke-from-cloudwatch-logs" {
  statement_id  = "invoke-from-cloudwatch-logs"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cloudfront-logs-api-key-to-google-analytics.arn}"
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.lambda-at-edge-log-group.arn}"
  provider      = "aws.${var.region}"
}

resource "aws_cloudwatch_log_group" "lambda-at-edge-log-group" {
  name     = "/aws/lambda/us-east-1.log-api-key-to-cloudwatch"
  provider = "aws.${var.region}"
}

resource "aws_cloudwatch_log_subscription_filter" "logs-lambda-subscription" {
  depends_on      = ["aws_lambda_permission.invoke-from-cloudwatch-logs", "aws_cloudwatch_log_group.lambda-at-edge-log-group"]
  name            = "logs-lambda-subscription"
  provider        = "aws.${var.region}"
  log_group_name  = "/aws/lambda/us-east-1.log-api-key-to-cloudwatch"
  filter_pattern  = "apikey"
  destination_arn = "${aws_lambda_function.cloudfront-logs-api-key-to-google-analytics.arn}"
}
