resource "aws_elb" "load_balancer" {
  count = "${signum(var.instance_count)}"

  # replace discovery with disco to ensure name does not exceed string length limit
  name = "${replace(format("%s--%s", replace(var.vpc_name,"discovery","disco"), var.id),"_","-")}"
  subnets = [ "${var.public_subnet_ids}" ]
  security_groups = ["${aws_security_group.load_balancer.id}"]

  listener = {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener = {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.certificate_arn}"
  }

  instances = ["${aws_instance.instance.*.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/robots.txt" // in future, should we use dropwizard healthchecks?
    interval = 30
  }
}

resource "aws_security_group" "load_balancer" {
  name = "${var.vpc_name}-${var.id}-elb"
  description = "Presentation ELB security group"
  vpc_id = "${var.vpc_id}"

  count = "${signum(var.instance_count)}"

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

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    security_groups = ["${var.security_group_ids}"]
  }
}

# FIXME: disabled while we migrate everything over
#
# resource "aws_route53_record" "load_balancer" {
#   count = "${signum(var.instance_count)}"
#   zone_id = "${var.dns_zone_id}"
#   name = "${var.id}.${var.vpc_name}.${var.dns_domain}"
#   type = "CNAME"
#   ttl = "${var.dns_ttl}"
#   records = [ "${aws_elb.load_balancer.dns_name}" ]
# }
