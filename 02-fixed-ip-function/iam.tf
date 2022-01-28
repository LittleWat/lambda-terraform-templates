resource "aws_iam_role" "fixed_ip_function" {
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY

  max_session_duration = "3600"
  name                 = "${var.service_name}-fixed-ip-lambda-role"
  path                 = "/"
}

resource "aws_iam_role_policy_attachment" "fixed_ip_function_AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.fixed_ip_function.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
