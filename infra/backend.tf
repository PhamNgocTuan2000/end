terraform {
  backend "s3" {
    bucket = "ptuan-state"
    key = "tfstate"
    region = "ap-northeast-1"
  }
}