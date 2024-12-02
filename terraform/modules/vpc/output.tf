output "out_vpc_id" {
  value =  aws_vpc.vpc.id
}

output "out_public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "out_private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}