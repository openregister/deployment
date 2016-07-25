resource "aws_elb" "load_balancer" {
  count = "${var.enabled}"

  # replace discovery with disco to ensure name does not exceed string length limit
  name = "${replace(format("%s-%s", replace(var.vpc_name,"discovery","disco"), var.id),"_","-")}"
  subnets = [ "${split(" ", var.subnet_ids)}" ]
  security_groups = ["${aws_security_group.load_balancer.id}"]

  listener = {
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener = {
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.certificate_arn}"
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
