//init the terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  # Configuration options
  # profile = "default"
  region  = "ap-northeast-1"
}