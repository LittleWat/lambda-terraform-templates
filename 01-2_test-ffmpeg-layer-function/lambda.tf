data "archive_file" "test_ffmpeg_layer_function" {
  type        = "zip"
  source_dir  = "src"
  output_path = "test_ffmpeg_layer_function.zip"
}

data "aws_lambda_layer_version" "ffmpeg" {
  layer_name = var.ffmpeg_lambda_layer_name
}


resource "aws_lambda_function" "test_ffmpeg_layer_function" {
  filename         = data.archive_file.test_ffmpeg_layer_function.output_path
  function_name    = "${var.service_name}-function"
  description      = "test ffmpeg/ffprobe lambda layer function"
  role             = aws_iam_role.test_ffmpeg_layer_function.arn
  source_code_hash = data.archive_file.test_ffmpeg_layer_function.output_base64sha256
  runtime          = "python3.9"
  handler          = "test_ffmpeg_layer_function.lambda_handler"
  timeout          = 900
  memory_size      = 1024
  publish          = true
  layers           = [data.aws_lambda_layer_version.ffmpeg.arn]

  environment {
    variables = {
      OUTPUT_BUCKET = aws_s3_bucket.wav_output.bucket
    }
  }
}

resource "aws_lambda_permission" "allow-test-wav-input-bucket" {
  statement_id  = "allow-test-wav-input-bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_ffmpeg_layer_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.wav_input.arn
}

resource "aws_s3_bucket_notification" "test-wav-input-bucket-notification" {
  bucket = aws_s3_bucket.wav_input.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_ffmpeg_layer_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".wav"
  }

  depends_on = [aws_lambda_permission.allow-test-wav-input-bucket]
}
