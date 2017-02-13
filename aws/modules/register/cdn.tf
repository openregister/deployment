resource "aws_cloudfront_distribution" "distribution" {
  count = "${var.enabled && var.cdn_configuration["enabled"] ? 1 : 0}"

  aliases = ["${var.name}.${var.cdn_configuration["domain"]}"]
  enabled = true
  http_version = "http2"
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

  cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods = ["HEAD", "GET"]

    path_pattern = "robots.txt"

    default_ttl = 86400
    max_ttl = 31536000
    min_ttl = 0

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = true
      headers = ["Origin"]
    }

    target_origin_id = "${var.environment}-${var.name}-robots-txt"
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

  origin {
    domain_name = "${var.cdn_configuration["robots_bucket"]}.s3.amazonaws.com"
    origin_id = "${var.environment}-${var.name}-robots-txt"
    origin_path = "/${var.name}"

    s3_origin_config = {
      origin_access_identity = "${var.cdn_s3_origin_access_identity}"
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

resource "aws_s3_bucket_object" "robots_txt" {
  count = "${var.enabled && var.cdn_configuration["enabled"] ? 1 : 0}"

  bucket = "${var.cdn_configuration["robots_bucket"]}"
  key = "${var.name}/robots.txt"
  content_type = "text/plain"
  content =  <<EOF
# ${var.name}.${var.cdn_configuration["domain"]}
User-agent: *
Disallow: /
EOF
}
