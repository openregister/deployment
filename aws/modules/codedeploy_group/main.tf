resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  deployment_group_name = "${var.id}"
  app_name = "${var.application}"
  service_role_arn = "${var.service_role_arn}"
  deployment_config_name = "${var.config_name}"
  ec2_tag_filter {
    key = "DeploymentGroup"
    type = "KEY_AND_VALUE"
    value = "${var.tag}"
  }
}
