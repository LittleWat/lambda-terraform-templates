data "archive_file" "ffmpeg" {
  type        = "zip"
  source_dir  = "./build/layer"
  output_path = "./ffmpeg.zip"
}

resource "aws_s3_bucket" "ffmpeg_lambda_layer" {
  bucket = var.ffmpeg_lambda_layer_bucket
  acl    = "private"
}

resource "aws_s3_bucket_object" "ffmmpeg" {
  bucket = aws_s3_bucket.ffmpeg_lambda_layer.bucket
  key    = "ffmpeg.zip"
  source = data.archive_file.ffmpeg.output_path
  etag   = filemd5(data.archive_file.ffmpeg.output_path)
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = var.ffmpeg_lambda_layer_name

  ## Use s3_bucket, s3_key instead of filename to avoid Error creating lambda layer: RequestEntityTooLargeException
  # filename = data.archive_file.ffmpeg.output_path

  s3_bucket = aws_s3_bucket_object.ffmmpeg.bucket
  s3_key    = aws_s3_bucket_object.ffmmpeg.key

  compatible_runtimes = ["python3.9"]
  source_code_hash    = data.archive_file.ffmpeg.output_base64sha256
}
