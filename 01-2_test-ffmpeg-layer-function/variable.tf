variable "region" {
  default = "ap-northeast-1"
  type = string
}
variable "service_name" {
  default = "test-ffmpeg"
  type = string
}
variable "ffmpeg_lambda_layer_name" {
  default = "ffmpeg-lambda-layer"
  type    = string
}