data "archive_file" "fixed_ip_function" {
  type        = "zip"
  source_dir  = "src"
  output_path = "fixed_ip_function.zip"
}

resource "aws_lambda_function" "fixed_ip_function" {
  filename         = data.archive_file.fixed_ip_function.output_path
  function_name    = "${var.service_name}-fixed-ip-function"
  description      = "Fixed IP Function"
  role             = aws_iam_role.fixed_ip_function.arn
  source_code_hash = data.archive_file.fixed_ip_function.output_base64sha256
  runtime          = "python3.9"
  handler          = "fixed_ip_function.lambda_handler"
  timeout          = 300
  publish          = "true"

  vpc_config {
    subnet_ids         = [aws_subnet.main_lambda_private_subnet_1a.id, aws_subnet.main_lambda_private_subnet_1c.id]
    security_group_ids = [aws_default_security_group.default_security_group.id]
  }
}
