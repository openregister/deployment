provider "aws" {
  region = "eu-west-1"
}

module "aws-security-alarms" {
  source                      = "git::github.com/alphagov/aws-security-alarms.git//terraform?ref=89c8f28c16b91f06cc4aa5765786614653cc9d57"
  cloudtrail_s3_bucket_name   = "cloudtrail-logs-openregister"
  cloudtrail_s3_bucket_prefix = "prod"
}
