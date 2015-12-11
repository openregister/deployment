resource "aws_route_table" "coreos-rt-tf" {
    vpc_id = "${aws_vpc.coreos-vpc-tf.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.coreos-vpc-gw-tf.id}"
    }

    tags {
        Name = "CoreOS route table (tf)"
    }
}
