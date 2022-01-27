resource "aws_iam_role" "test_ffmpeg_layer_function" {
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
  name                 = "${var.service_name}_lambda_role"
  path                 = "/"
}

resource "aws_iam_role_policy_attachment" "test_ffmpeg_layer_function_AWSLambdaExecute" {
  role       = aws_iam_role.test_ffmpeg_layer_function.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
