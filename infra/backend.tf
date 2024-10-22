terraform {
  backend "s3" {
    bucket = "hungnv-state"
    key = "tfstate"
    region = "ap-south-1"
  }
}