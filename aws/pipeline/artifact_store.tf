resource "aws_s3_bucket_policy" "artifact_store" {
  bucket = "${aws_s3_bucket.artifact_store.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "SSEAndSSLPolicy",
  "Statement": [{
    "Sid": "DenyUnEncryptedObjectUploads",
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:PutObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.artifact_store.id}/*",
    "Condition": {
      "StringNotEquals": {
        "s3:x-amz-server-side-encryption": "aws:kms"
      }
    }
  }, {
    "Sid": "DenyInsecureConnections",
    "Effect": "Deny",
    "Principal": "*",
    "Action": "s3:*",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.artifact_store.id}/*",
    "Condition": {
      "Bool": {
        "aws:SecureTransport": "false"
      }
    }
  }]
}
EOF
}

resource "aws_s3_bucket" "artifact_store" {
  bucket = "codepipeline-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}

