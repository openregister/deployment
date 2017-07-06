resource "aws_cloudwatch_event_rule" "every_hour" {
    name = "every-hour"
    description = "Fires every hour"
    schedule_expression = "cron(30 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_every_hour" {
    rule = "${aws_cloudwatch_event_rule.every_hour.name}"
    target_id = "pingdom_availability_to_performance_platform"
    arn = "${aws_lambda_function.pingdom_availability_to_performance_platform.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.pingdom_availability_to_performance_platform.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_hour.arn}"
}

resource "aws_lambda_function" "pingdom_availability_to_performance_platform" {
    filename = "build/python/pingdom-to-performance-platform.zip"
    function_name = "pingdom_availability_to_performance_platform"
    role = "${aws_iam_role.lambda.arn}"
    handler = "lambda.lambda_handler"
    runtime = "python3.6"
    timeout = 20
    source_code_hash = "${base64sha256(file("build/python/pingdom-to-performance-platform.zip"))}"
}
