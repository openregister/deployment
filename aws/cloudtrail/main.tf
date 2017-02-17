provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  name = "CloudTrail-all-regions"
  enable_log_file_validation = true
  s3_bucket_name = "${aws_s3_bucket.local-bucket.id}"
  s3_key_prefix = "prod"
  include_global_service_events = true
  is_multi_region_trail = true
}

resource "aws_s3_bucket" "local-bucket" {
  bucket = "cloudtrail-logs-openregister"
  force_destroy = true
  versioning = {
    enabled = true
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail-logs-openregister"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail-logs-openregister/prod/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

module "ship-to-central-bucket" {
  source                      = "git::github.com/alphagov/aws-security-alarms.git//terraform?ref=d3382473690a5389e45effd1b1a03df723a97588"
  cloudtrail_s3_bucket_name   = "${var.central_cloudtrail_bucket_name}"
  cloudtrail_s3_bucket_prefix = "prod"
}
