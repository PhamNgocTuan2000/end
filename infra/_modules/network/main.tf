
locals {
  #calculate the number of availability zones
  azs = var.azs
}

//create VPC
resource "aws_vpc" "hungnv-vpc" {
  cidr_block = var.cidrvpc

  tags = var.tags
}

//

//Create public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.hungnv-vpc.id
  availability_zone = var.aznames[count.index]
  count             = local.azs
  map_public_ip_on_launch = true
  cidr_block        = cidrsubnet(aws_vpc.hungnv-vpc.cidr_block, 8, count.index)
  tags = merge({
    "ext-name" = "${var.vpc_name}-public-subnet"
  }, var.tags)

}

//create internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.hungnv-vpc.id
  tags = merge({
    Name = "${var.vpc_name}-igw"
  }, var.tags)
}

resource "aws_route" "main_route" {
  route_table_id         = aws_vpc.hungnv-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}

//associate route table with public subnet
resource "aws_route_table_association" "public_subnet_rtb" {
  count          = local.azs
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_vpc.hungnv-vpc.main_route_table_id
}

//create eip 
resource "aws_eip" "nateip" {
  count = local.azs
  tags = merge({
    ext-name = "${var.vpc_name}-eip-${count.index}"
  }, var.tags)
}

//create nat gateway
resource "aws_nat_gateway" "nat" {
  count         = local.azs
  allocation_id = element(aws_eip.nateip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags = merge({
    ext-name = "${var.vpc_name}-nat-${count.index}"
  }, var.tags)
}

//create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.hungnv-vpc.id
  availability_zone = var.aznames[count.index]
  count             = local.azs
  cidr_block        = cidrsubnet(aws_vpc.hungnv-vpc.cidr_block, 8, count.index + local.azs)
  map_public_ip_on_launch = true
  tags = merge({
    "ext-name" = "${var.vpc_name}-private-subnet"
  }, var.tags)

}


//create route table for private subnet
resource "aws_route_table" "private_rtb" {
  count  = local.azs
  vpc_id = aws_vpc.hungnv-vpc.id

  #define route table for private subnet
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
  tags = merge(
    {
      ext-name = "${var.vpc_name}-private-rtb-${count.index}"
    },
    var.tags
  )
}

//asoociate route table with private subnet
resource "aws_route_table_association" "private_subnet_rtb" {
  count          = local.azs
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_rtb.*.id, count.index)
}

