provider "aws" {
  region = "eu-west-1"
}

module "aws-security-alarms" {
  source                      = "github.com/alphagov/aws-security-alarms//terraform"
  cloudtrail_s3_bucket_name   = "cloudtrail-logs-openregister"
  cloudtrail_s3_bucket_prefix = "prod"
}

module "unexpected-ip-access" {
  source               = "github.com/alphagov/aws-security-alarms//terraform/alarms/unexpected_ip_access"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security-alerts-topic}"]
}

module "unauthorized-activity" {
  source               = "github.com/alphagov/aws-security-alarms//terraform/alarms/unauthorized_activity"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security-alerts-topic}"]
}

module "root-activity" {
  source               = "github.com/alphagov/aws-security-alarms//terraform/alarms/root_activity"
  environment_name     = "test"
  cloudtrail_log_group = "${module.aws-security-alarms.cloudtrail_log_group}"
  alarm_actions        = ["${module.aws-security-alarms.security-alerts-topic}"]
}
