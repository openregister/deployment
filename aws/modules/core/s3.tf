resource "aws_s3_bucket" "register" {
  bucket = "openregister.${var.vpc_name}.config"

  tags = {
    Name = "openregister.${var.vpc_name}.config"
    Environment = "${var.vpc_name}"
  }
}
