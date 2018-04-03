resource "aws_lambda_permission" "allow_lambda_execution_from_cloudtrail_log_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cloudtrail_logs_to_sumologic.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::cloudtrail-logs-openregister"
}

resource "aws_s3_bucket_notification" "cloudtrail_bucket_notification" {
  bucket = "cloudtrail-logs-openregister"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.cloudtrail_logs_to_sumologic.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_function" "cloudtrail_logs_to_sumologic" {
  filename         = "build/node/cloudtrail-s3-logs-to-sumologic.zip"
  function_name    = "cloudtrail_logs_to_sumologic"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "lambda.handler"
  runtime          = "nodejs4.3"
  timeout          = 20
  source_code_hash = "${base64sha256(file("build/node/cloudtrail-s3-logs-to-sumologic.zip"))}"
}
