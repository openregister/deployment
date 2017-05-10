resource "aws_cloudwatch_event_rule" "every_day" {
    name = "every-day"
    description = "Fires every day"
    schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_every_day" {
    rule = "${aws_cloudwatch_event_rule.every_day.name}"
    target_id = "statuscake_availability_to_performance_platform"
    arn = "${aws_lambda_function.statuscake_availability_to_performance_platform.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.statuscake_availability_to_performance_platform.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_day.arn}"
}

resource "aws_lambda_function" "statuscake_availability_to_performance_platform" {
    filename = "build/python/statuscake-to-performance-platform.zip"
    function_name = "statuscake_availability_to_performance_platform"
    role = "${aws_iam_role.lambda.arn}"
    handler = "lambda.lambda_handler"
    runtime = "python3.6"
    timeout = 20
    source_code_hash = "${base64sha256(file("build/python/statuscake-to-performance-platform.zip"))}"
}
