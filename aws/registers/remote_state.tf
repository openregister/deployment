resource "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tf.statefiles"
    key = "${var.vpc_name}"
  }
}
