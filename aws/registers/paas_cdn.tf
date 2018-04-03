data "aws_caller_identity" "current" {}

variable "api_key_to_cloudfront_logs_version_number" {}

resource "aws_cloudfront_distribution" "paas_cdn" {
  count = 1

  aliases      = ["*.${var.environment_name}.openregister.org"]
  enabled      = true
  http_version = "http2"
  price_class  = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = "${var.paas_cdn_certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["HEAD", "GET"]

    default_ttl = 0
    max_ttl     = 0
    min_ttl     = 0

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = true
      headers      = ["Accept", "Host", "Origin", "X-Forwarded-Host"]
    }

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:log-api-key-to-cloudwatch:${var.api_key_to_cloudfront_logs_version_number}"
    }

    target_origin_id       = "paas"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = "cloudapps.digital"
    origin_id   = "paas"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket = "${var.paas_cdn_configuration["logging_bucket"]}.s3.amazonaws.com"
    prefix = "paas-${var.environment_name}"
  }
}
