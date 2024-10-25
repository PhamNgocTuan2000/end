
locals {
  #calculate the number of availability zones
  azs = length(data.aws_availability_zones.available.names)
}

//calling the network module

module "vpc" {
  source   = "./_modules/network"
  azs      = local.azs
  vpc_name = var.vpc_name
  tags     = merge(var.tags,{
    "ext-tag"= terraform.workspace
  })
  cidrvpc  = var.cidrvpc
  aznames  = data.aws_availability_zones.available.names
}


module "rds" {
  source = "./_modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "s3" {
  source = "./_modules/s3"
  bucket_name = var.s3_bucket_name
  db_name = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  ecr_repository_name = var.ecr_repository_name
  s3_bucket_name = var.s3_bucket_name
}

module "ecr" {
  source = "./_modules/ecr"
  repository_name = var.ecr_repository_name

}

module "eks" {
  source       = "./_modules/eks"
  cluster_name = var.eks_cluster_name
  subnet_ids   = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
}


# module "s3" {
#   count = var.create_s3_bucket ? 1 : 0
#   source = "./_modules/s3"
# }
