provider "aws" {
  region = "eu-west-1"
}

module "aws-security-alarms" {
  source                      = "git::github.com/alphagov/aws-security-alarms.git//terraform?ref=89c8f28c16b91f06cc4aa5765786614653cc9d57"
  cloudtrail_s3_bucket_name   = "cloudtrail-logs-openregister"
  cloudtrail_s3_bucket_prefix = "prod"
}

module "unexpected-ip-access" {
  source               = "git::github.com/alphagov/aws-security-alarms.git//terraform/alarms/unexpected_ip_access?ref=89c8f28c16b91f06cc4aa5765786614653cc9d57"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security_alerts_topic}"]
}

module "unauthorized-activity" {
  source               = "git::github.com/alphagov/aws-security-alarms.git//terraform/alarms/unauthorized_activity?ref=89c8f28c16b91f06cc4aa5765786614653cc9d57"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security_alerts_topic}"]
}

module "root-activity" {
  source               = "git::github.com/alphagov/aws-security-alarms.git//terraform/alarms/root_activity?ref=89c8f28c16b91f06cc4aa5765786614653cc9d57"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security_alerts_topic}"]
}
