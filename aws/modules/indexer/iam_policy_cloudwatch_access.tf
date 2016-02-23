resource "aws_iam_role_policy" "iam_policy_cloudwatch_access" {
  name = "${format("%s_CloudWatch_PutMetricData", var.vpc_name)}"
  role = "${aws_iam_role.indexer.id}"
  policy = <<POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "Stmt1456223097000",
              "Effect": "Allow",
              "Action": [
                  "cloudwatch:PutMetricData"
              ],
              "Resource": [
                  "*"
              ]
          }
      ]
  }
POLICY
}
