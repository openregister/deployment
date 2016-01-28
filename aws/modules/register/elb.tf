resource "aws_elb" "register" {
  name = "${var.vpc_name}-${var.id}-elb"
  subnets = [ "${split(" ", var.subnet_ids)}" ]

  listener = {
    instance_port = "${var.elb_instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}
