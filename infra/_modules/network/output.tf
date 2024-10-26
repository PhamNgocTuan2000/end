output "vpc_id" {
  value = aws_vpc.ptuan-vpc.id
}

//export the public subnet id
output "public_subnet_id" {
  value = data.aws_subnets.public.ids
}

output "private_subnet_id" {
  value = data.aws_subnets.private.ids
  
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}