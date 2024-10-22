variable "bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
}

variable "db_name" {
  description = "Name of the RDS database"
  default     = "mydb"
}

variable "db_username" {
  description = "Username for the RDS database"
}

variable "db_password" {
  description = "Password for the RDS database"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
}