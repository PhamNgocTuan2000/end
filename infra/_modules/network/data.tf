
data "aws_subnets" "private" {
  filter {
   name = "tag:ext-name"
   values =  ["${var.vpc_name}-private-subnet"]
  }
  # filter {
  #   name   = "tag:Name"
  #   values = ["${var.vpc_name}-private-subnet"]
  # }
  # tags = {
  #   Name = "${var.vpc_name}-private-subnet"
  # }
}

data "aws_subnets" "public" {
   filter {
   name = "tag:ext-name"
   values =  ["${var.vpc_name}-public-subnet"]
  }

  # tags = {
  #   Name = "${var.vpc_name}-public-subnet"
  # }
  
}
