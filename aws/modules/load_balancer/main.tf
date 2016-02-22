resource "aws_elb" "load_balancer" {
  name = "${replace(format("%s-%s-elb", var.vpc_name, var.id),"_","-")}"
  subnets = [ "${split(" ", var.subnet_ids)}" ]
  security_groups = ["${aws_security_group.load_balancer.id}"]

  listener = {
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  instances = [ "${split(" ", var.instance_ids)}" ]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/robots.txt" // in future, should we use dropwizard healthchecks?
    interval = 30
  }
}
