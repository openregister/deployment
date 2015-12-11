resource "aws_route_table_association" "coreos-rta-tf" {
    subnet_id = "${aws_subnet.coreos-subnet-tf.id}"
    route_table_id = "${aws_route_table.coreos-rt-tf.id}"
}
