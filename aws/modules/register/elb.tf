resource "aws_security_group" "register_elb" {
  name = "${var.vpc_name}-${var.id}-elb-sg"
  description = "Presentation ELB security group"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.vpc_name}-${var.id}-sg"
    Environment = "${var.vpc_name}"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "register" {
  name = "${var.vpc_name}-${var.id}-elb"
  subnets = [ "${split(" ", var.subnet_ids)}" ]

  security_groups = ["${aws_security_group.register_elb.id}"]

  listener = {
    instance_port = "${var.elb_instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}
