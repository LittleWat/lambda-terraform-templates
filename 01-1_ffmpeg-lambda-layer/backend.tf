terraform {
  backend "s3" {
    key    = "ffmpeg-lambda-layer.tfstate"
    region = "ap-northeast-1"
  }
}
