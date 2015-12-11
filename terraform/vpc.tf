resource "aws_vpc" "coreos-vpc-tf" {
    cidr_block = "172.20.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "CoreOS VPC (tf)"
    }
}
