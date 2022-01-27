resource "aws_s3_bucket" "wav_input" {
  bucket = "test-main-wav-input"
  acl    = "private"
}

resource "aws_s3_bucket" "wav_output" {
  bucket = "test-main-wav-output"
  acl    = "private"
}
