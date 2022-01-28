variable "region" {
  default = "ap-northeast-1"
  type    = string
}

variable "ffmpeg_lambda_layer_name" {
  default = "ffmpeg-lambda-layer"
  type    = string
}

variable "ffmpeg_lambda_layer_bucket" {
  default = "ffmpeg-lambda-layer-src"
  type    = string
}
