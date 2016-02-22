resource "aws_vpc" "registers" {
  // The CIDR block for the VPC.
  cidr_block = "${var.vpc_cidr_block}"

  // A boolean flag to enable/disable DNS support in the VPC.
  enable_dns_support = true

  // A boolean flag to enable/disable DNS hostnames in the VPC
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
    Environment = "${var.vpc_name}"
  }
}
