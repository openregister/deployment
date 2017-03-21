resource "aws_db_parameter_group" "db" {
  name   = "${var.id}"
  family = "postgres9.5"

  parameter {
    name = "log_hostname"
    value = false
    apply_method = "immediate"
  }
}
