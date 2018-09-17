provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  region = "${var.region}"
  alias  = "${var.region}"
}

data "aws_iam_role" "lambda_role" {
  role_name = "lambda"
}

/*
https://github.com/terraform-providers/terraform-provider-aws/issues/1262
data "aws_s3_bucket" "cloudfront-logs-register-gov-uk" {
  bucket = "cloudfront-logs-register-gov-uk"
}
*/
resource "aws_s3_bucket" "cloudfront-logs-register-gov-uk" {
  bucket = "cloudfront-logs-register-gov-uk"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.log-anonymiser-register-gov-uk.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.cloudfront-logs-register-gov-uk.arn}"
  provider         = "aws.${var.region}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.cloudfront-logs-register-gov-uk.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.log-anonymiser-register-gov-uk.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".gz"
  }
  provider         = "aws.${var.region}"
}

data "archive_file" "log-anonymiser-archive" {
  output_path = "build/python/log-anonymiser.zip"
  type = "zip"
  source_dir = "build/python/log-anonymiser"
}

resource "aws_lambda_function" "log-anonymiser-register-gov-uk" {
  filename         = "build/python/log-anonymiser.zip"
  source_code_hash = "${data.archive_file.log-anonymiser-archive.output_base64sha256}"
  function_name    = "log-anonymiser-register-gov-uk"
  role             = "${data.aws_iam_role.lambda_role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "python3.6"
  timeout          = 60
  environment      = {
    variables = {
      TARGET_BUCKET = "cloudfront-logs-register-gov-uk-anonymised"
    }
  }
  provider         = "aws.${var.region}"
}