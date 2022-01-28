terraform {
  backend "s3" {
    key    = "fixed-ip-lambda-tfstate"
    region = "ap-northeast-1"
  }
}