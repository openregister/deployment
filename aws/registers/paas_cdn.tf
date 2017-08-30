resource "aws_cloudfront_distribution" "paas_cdn" {
  count = 1

  aliases = ["*.${var.vpc_name}.openregister.org"]
  enabled = true
  http_version = "http2"
  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = "${var.paas_cdn_certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["HEAD", "GET"]

    default_ttl = 86400
    max_ttl = 31536000
    min_ttl = 0

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = true
      headers = ["Accept", "Host", "Origin", "X-Forwarded-Host"]
    }

    target_origin_id = "paas"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = "cloudapps.digital"
    origin_id = "paas"
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
    bucket = "${var.paas_cdn_configuration["logging_bucket"]}.s3.amazonaws.com"
    prefix = "paas-${var.vpc_name}"
  }
}
