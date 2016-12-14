resource "aws_cloudfront_distribution" "cloudfront" {
  count = "${signum(var.enable_cdn * var.instance_count)}"
  enabled = true

  aliases = ["${var.id}.register.gov.uk"]

  http_version = "http1.1"

  origin {
    domain_name = "${aws_route53_record.load_balancer.fqdn}"
    origin_id   = "register_origin"

    custom_origin_config {
      http_port = 80 # "required" but not used

      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    default_ttl = 300

    forwarded_values {
      headers = ["Accept", "Host", "Origin"]

      cookies {
        forward = "none"
      }
      query_string = true
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 300
    max_ttl = 300
    target_origin_id = "register_origin"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket = "cloudfront-logs-register-gov-uk.s3.amazonaws.com"
    prefix = "${var.id}"
    include_cookies = false
  }

  viewer_certificate {
    iam_certificate_arn = "${var.cloudfront_certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}
