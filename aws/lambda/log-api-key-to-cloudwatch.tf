resource "aws_iam_role" "lambda-edge-role" {
  name = "lambda-edge-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service":[
          "lambda.amazonaws.com",
        	"edgelambda.amazonaws.com"
          ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-edge-policy" {
  name = "lambda-edge-policy"
  role = "${aws_iam_role.lambda-edge-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "lambda:UpdateEventSourceMapping",
            "lambda:ListFunctions",
            "lambda:GetEventSourceMapping",
            "logs:PutDestinationPolicy",
            "lambda:CreateEventSourceMapping",
            "logs:CreateLogGroup",
            "logs:PutResourcePolicy",
            "iam:CreateServiceLinkedRole",
            "lambda:ListEventSourceMappings",
            "cloudfront:UpdateDistribution",
            "logs:PutDestination",
            "logs:DescribeResourcePolicies",
            "logs:DescribeDestinations"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "lambda:*",
        "Resource": "arn:aws:lambda:*:*:function:*"
    },
    {
        "Effect": "Allow",
        "Action": "logs:*",
        "Resource": [
            "arn:aws:logs:*:*:log-group:*",
            "arn:aws:logs:*:*:log-group:*:*:*"
        ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "api-key-to-cloudfront-logs" {
  function_name    = "log-api-key-to-cloudwatch"
  filename         = "build/node/log-api-key-to-cloudwatch.zip"
  source_code_hash = "${base64sha256(file("build/node/log-api-key-to-cloudwatch.zip"))}"
  handler          = "lambda.handler"
  role             = "${aws_iam_role.lambda-edge-role.arn}"
  memory_size      = "128"
  runtime          = "nodejs6.10"
  timeout          = "5"
  provider         = "aws.us-east-1"
  publish          = true
}

output "api_key_to_cloudfront_logs_version_number" {
  value = "${aws_lambda_function.api-key-to-cloudfront-logs.version}"
}
