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

resource "aws_security_group" "coreos-ct-tf" {
  name = "Expose HTTP"
  description = "HTTP access from anywhere"
  vpc_id = "${aws_vpc.coreos-vpc-tf.id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "CoreOS HTTP (TF)"
  }
}
