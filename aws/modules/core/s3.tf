resource "aws_s3_bucket" "register" {
  bucket = "openregister.${var.environment_name}.config"

  tags = {
    Name = "openregister.${var.environment_name}.config"
    Environment = "${var.environment_name}"
  }
}
