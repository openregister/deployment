resource "aws_instance" "coreos-instances-tf" {
    count = 3
    ami = "ami-fd6ccd8e"
    instance_type = "t1.micro"
    user_data = "${file("etcd.yml")}"
    subnet_id = "${aws_subnet.coreos-subnet-tf.id}"
    vpc_security_group_ids = [ "${aws_security_group.coreos-tf.id}" ]

    tags {
      Name = "etcd #${count.index} (coreos) (tf)"
    }
}

resource "aws_instance" "coreos-certificate-transparency-docker-tf" {
    depends_on = ["aws_instance.coreos-instances-tf"]
    ami = "ami-fd6ccd8e"
    instance_type = "t1.micro"
    user_data = "${file("certificate-transparency.yml")}"
    subnet_id = "${aws_subnet.coreos-subnet-tf.id}"
    vpc_security_group_ids = [ "${aws_security_group.coreos-tf.id}", "${aws_security_group.coreos-ct-tf.id}" ]

    tags {
      Name = "CT (coreos) (tf)"
    }
}
