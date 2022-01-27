terraform {
  backend "s3" {
    key    = "test-ffmpeg-layer-function.tfstate"
    region = "ap-northeast-1"
  }
}
