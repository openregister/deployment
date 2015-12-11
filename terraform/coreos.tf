provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "eu-west-1"
}

resource "aws_vpc" "coreos-vpc-tf" {
    cidr_block = "172.20.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags {
        Name = "CoreOS VPC (tf)"
    }
}

resource "aws_internet_gateway" "coreos-vpc-gw-tf" {
    vpc_id = "${aws_vpc.coreos-vpc-tf.id}"

    tags {
        Name = "VPC Gateway (tf)"
    }
}

resource "aws_subnet" "coreos-subnet-tf" {
    vpc_id = "${aws_vpc.coreos-vpc-tf.id}"
    cidr_block = "172.20.10.0/24"
    map_public_ip_on_launch = "true"
    tags {
        Name = "Test-A (tf)"
    }
}

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

resource "aws_route_table_association" "coreos-rta-tf" {
    subnet_id = "${aws_subnet.coreos-subnet-tf.id}"
    route_table_id = "${aws_route_table.coreos-rt-tf.id}"
}

resource "aws_security_group" "coreos-tf" {
  name = "CoresOS testing security group (TF)"
  description = "SSH from anywhere, and local ETCD connections"
  vpc_id = "${aws_vpc.coreos-vpc-tf.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "icmp"
    from_port = 8
    to_port = 0
  }

  ingress {
      from_port = 2379
      to_port = 2380
      protocol = "tcp"
      self = true
  }

  ingress {
      from_port = 4001
      to_port = 4001
      protocol = "tcp"
      self = true
  }

  ingress {
      from_port = 7001
      to_port = 7001
      protocol = "tcp"
      self = true
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "CoreOS testing security group (tf)"
  }
}

resource "aws_instance" "coreos-tf-example" {
    count = 3
    ami = "ami-fd6ccd8e"
    instance_type = "t1.micro"
    user_data = "${file("../etcd.yml")}"
    subnet_id = "${aws_subnet.coreos-subnet-tf.id}"
    vpc_security_group_ids = [ "${aws_security_group.coreos-tf.id}" ]

    tags {
      Name = "coreos (instance ${count.index}) (tf)"
    }
}
