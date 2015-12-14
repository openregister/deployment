resource "aws_internet_gateway" "coreos-vpc-gw-tf" {
    vpc_id = "${aws_vpc.coreos-vpc-tf.id}"

    tags {
        Name = "VPC Gateway (tf)"
    }
}
