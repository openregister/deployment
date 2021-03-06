resource "aws_s3_bucket" "s3_redirect" {
  count = "${var.enabled ? 1 : 0}"
  bucket = "${var.from}"
  acl = "public-read"

  website {
    redirect_all_requests_to = "${var.to}"
  }
}

resource "aws_cloudfront_distribution" "cf_redirect" {
  count = "${var.enabled ? 1 : 0}"
  origin {
    domain_name = "${aws_s3_bucket.s3_redirect.website_endpoint}"
    origin_id   = "${var.from}"

    custom_origin_config {
      http_port = 80
      origin_protocol_policy = "http-only"

      https_port = 443 # "required" but not used
      origin_ssl_protocols = ["TLSv1.2"] # ditto
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    default_ttl = 300
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = true
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 300
    max_ttl = 300
    target_origin_id = "${var.from}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  aliases = ["${var.from}"]
  enabled = "${var.enabled ? 1 : 0}"
}

resource "aws_route53_record" "r53_redirect" {
  count = "${var.enabled ? 1 : 0}"
  zone_id = "${var.dns_zone_id}"
  name = "${var.from}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cf_redirect.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cf_redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}
