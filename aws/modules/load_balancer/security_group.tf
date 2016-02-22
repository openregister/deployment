resource "aws_security_group" "load_balancer" {
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
