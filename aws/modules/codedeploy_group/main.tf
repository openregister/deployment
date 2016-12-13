resource "aws_sns_topic" "deployments" {
  name = "deployments-${var.id}"
}

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

  trigger_configuration {
    trigger_events = ["DeploymentStart", "DeploymentFailure", "DeploymentSuccess"]
    trigger_name = "Send to Slack"
    trigger_target_arn = "${aws_sns_topic.deployments.arn}"
  }
}
