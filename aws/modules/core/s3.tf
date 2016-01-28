resource "aws_s3_bucket" "register" {
  bucket = "registers.${var.vpc_name}.config"

  tags = {
    Name = "registers.${var.vpc_name}.config"
   Environment = "${var.vpc_name}"
  }
}
