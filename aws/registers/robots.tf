data "aws_iam_policy_document" "s3_policy" {
  count = "${var.cdn_configuration["enabled"] ? 1 : 0}"
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.robots.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.robots.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "robots" {
  count = "${var.cdn_configuration["enabled"] ? 1 : 0}"

  bucket = "${var.cdn_configuration["robots_bucket"]}"
}

resource "aws_s3_bucket_policy" "robots_bucket_policy" {
  count = "${var.cdn_configuration["enabled"] ? 1 : 0}"

  bucket = "${aws_s3_bucket.robots.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

// Create this resource in all environments not necessarily because it is needed
// (it is only required in environments that have a CDN) but because it simplifies
// having to deal with passing arguments to the `register` module that may not
// exist in some environments.
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}
