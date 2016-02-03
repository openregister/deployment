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

  egress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    security_groups = [ "${split(" ", var.security_group_ids)}" ]
  }
}

resource "aws_elb" "register" {
  name = "${var.vpc_name}-${var.id}-elb"
  subnets = [ "${split(" ", var.elb_subnet_ids)}" ]

  security_groups = ["${aws_security_group.register_elb.id}"]

  listener = {
    instance_port = "${var.elb_instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  instances = ["${aws_instance.register.*.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/robots.txt" // in future, should we use dropwizard healthchecks?
    interval = 30
  }
}
