resource "aws_subnet" "coreos-subnet-tf" {
    vpc_id = "${aws_vpc.coreos-vpc-tf.id}"
    cidr_block = "172.20.10.0/24"
    map_public_ip_on_launch = "true"
    tags {
        Name = "Test-A (tf)"
    }
}
