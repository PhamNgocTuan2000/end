variable "vpc_name" {
  default = "hungnv-tf-vpc"
}
variable "cidrvpc" {
  default = "10.0.0.0/16"
}

variable "tags" {
  default = {

    Name  = "hungnv-tf-vpc"
    Owner = "hungnv"
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

#bastion variable
variable "bastion_definition" {
  description = "The definition of bastion instance"
  # type = map(object({
  #   bastion_name                = string
  #   bastion_public_key          = string
  #   bastion_ami                 = string
  #   bastion_instance_class      = string
  #   trusted_ips                 = set(string)
  #   user_data_base64            = string
  #   associate_public_ip_address = bool
  #   bastion_monitoring          = bool
  # }))
  default = {
    "key" = {
      associate_public_ip_address = true
      bastion_ami                 = "ami-0c6359fd9eb30edcf"
      bastion_instance_class      = "t2.small"
      bastion_monitoring          = true
      bastion_name                = "vtidemo-bastion"
      bastion_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFAOt0e2Amvi38nYISAgN+WFjQhru6B/ixU8QKJddG+d+8ndGW9lVQ+EymZAsou3jnSfl5nT9BV0S3K8ogz48vGw8OkobT2LDZloBR6YVX4vsavicDhl56lOBRVTU892eH9YY/vcOf4K+cBQRItK+WnpjtpH+Lm7IEOAbMcOy7ypmfCJTnDh1h3JRgiB8S1fGpJyHNIT8m/SwadKlLds1cffL+44e4NxkjKWovdnOo0tqODoEsmxwSqj2ajahsYs6u6QTb7Ok22WDAaGXr6Syh4vWSDbxcbNAQl+36hsJpGWrIns47yl9zt7ln1/hMg77pAkdDQnFXpAgmJu3xT8TQckiL7P7zN4A7IkpxKZ0KB2+5h6pwoIijp2EGJpijVkC20+Ay1DXkBSbJIzfnTtmqoWw3dV6zd6rK0e/w4W/dhlKG66fekPH2sqYd3Yyo/PyI8bM18PXlKome0l8a0JTo1wLASprcUdJdmmML0yY6jwwcaw/OuIOJfRKTvxy6E2E= der@der"
      trusted_ips                 = ["171.241.35.242/32"]
      user_data_base64            = null
      ext-tags = {
        "ext-name" = "bastion"
        "func" = "bastion"
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