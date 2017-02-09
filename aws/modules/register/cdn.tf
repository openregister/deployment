resource "aws_cloudfront_distribution" "distribution" {
  count = "${var.enabled && var.cdn_configuration["enabled"] ? 1 : 0}"

  aliases = ["${var.name}.${var.cdn_configuration["domain"]}"]
  enabled = true
  http_version = "http1.1"
  price_class = "PriceClass_100"

  viewer_certificate {
    iam_certificate_id = "${var.cdn_configuration["certificate_id"]}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods = ["HEAD", "GET"]

    default_ttl = 86400
    max_ttl = 31536000
    min_ttl = 0

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = true
      headers = ["Accept", "Host", "Origin"]
    }

    target_origin_id = "${var.environment}-${var.name}-elb"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = "${aws_route53_record.record.fqdn}"
    origin_id = "${var.environment}-${var.name}-elb"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket = "${var.cdn_configuration["logging_bucket"]}.s3.amazonaws.com"
    prefix = "${var.name}"
  }
}
