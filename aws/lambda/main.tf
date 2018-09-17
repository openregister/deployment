terraform {
  required_version = "~> 0.9.0"

  backend "s3" {
    bucket  = "registers-cloudfront-terraform-state"
    key     = "cloudfront.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
  }
}

module "cloudfront_logs_api_key_to_google_analytics_us_east_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "us-east-1"
}

module "cloudfront_logs_api_key_to_google_analytics_us_east_2" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "us-east-2"
}

module "cloudfront_logs_api_key_to_google_analytics_us_west_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "us-west-1"
}

module "cloudfront_logs_api_key_to_google_analytics_us_west_2" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "us-west-2"
}

module "cloudfront_logs_api_key_to_google_analytics_ap_northeast_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ap-northeast-1"
}

module "cloudfront_logs_api_key_to_google_analytics_ap_northeast_2" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ap-northeast-2"
}

module "cloudfront_logs_api_key_to_google_analytics_ap_south_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ap-south-1"
}

module "cloudfront_logs_api_key_to_google_analytics_ap_southeast_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ap-southeast-1"
}

module "cloudfront_logs_api_key_to_google_analytics_ap_southeast_2" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ap-southeast-2"
}

module "cloudfront_logs_api_key_to_google_analytics_ca_central_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "ca-central-1"
}

# module "cloudfront_logs_api_key_to_google_analytics_cn_north_1" {
#   source = "node/cloudfront-logs-api-key-to-google-analytics"
#   region = "cn-north-1"
# }

module "cloudfront_logs_api_key_to_google_analytics_eu_central_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "eu-central-1"
}

module "cloudfront_logs_api_key_to_google_analytics_eu_west_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "eu-west-1"
}

module "cloudfront_logs_api_key_to_google_analytics_eu_west_2" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "eu-west-2"
}

# TODO: This region is not supported by the provider version we are using. Update provider to a version which supports this

# module "cloudfront_logs_api_key_to_google_analytics_eu_west_3" {
#   source = "node/cloudfront-logs-api-key-to-google-analytics"
#   region = "eu-west-3"
# }

module "cloudfront_logs_api_key_to_google_analytics_sa_east_1" {
  source = "node/cloudfront-logs-api-key-to-google-analytics"
  region = "sa-east-1"
}

module "cache_invalidator_eu_west_1" {
  source = "node/cache-invalidator"
  region = "eu-west-1"
}
module "cache_invalidator_eu_west_2" {
  source = "node/cache-invalidator"
  region = "eu-west-2"
}
module "cache_invalidator_eu_central_1" {
  source = "node/cache-invalidator"
  region = "eu-central-1"
}

module "log-anonymiser" {
  source = "python/log-anonymiser"
  region = "eu-west-2"
}

resource "aws_iam_role_policy" "s3_logs_lambda" {
  name = "s3_logs_lambda"
  role = "${aws_iam_role.lambda.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::cloudfront-logs-register-gov-uk/*",
        "arn:aws:s3:::cloudtrail-logs-openregister/*"
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
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda" {
  name = "lambda"

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
