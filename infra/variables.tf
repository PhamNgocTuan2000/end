variable "vpc_name" {
  default = "ptuan-tf-vpc"
}
variable "cidrvpc" {
  default = "10.0.0.0/16"
}

variable "tags" {
  default = {

    Name  = "ptuan-tf-vpc"
    Owner = "ptuan"
  }
}

variable "az_count" {
  default = 3
}

variable "vm-config" {
  default = {
    vm1 = {
      instance_type = "t2.small",
      tags = {
        "ext-name" = "vm1"
        "func" = "test"
      }
    }
    vm2 = {
      instance_type = "t2.medium"
      tags = {
        "ext-name" = "vm2"
        "func" = "test2"
      }
    }
  }
}


variable "create_s3_bucket" {
  default = true
}

variable "db_name" {
  description = "Name of the RDS database"
  # default     = "mydb"
}

variable "db_username" {
  description = "Username for the RDS database"
  # default = "myuser"
}

variable "db_password" {
  description = "Password for the RDS database"
  # default =  "mypassword"
  
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
  # default = "mybucket"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  # default = "myrepo"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  # default     = "hungnv-eks-cluster"
}