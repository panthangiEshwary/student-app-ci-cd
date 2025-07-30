output "vpc_id" {
  value = aws_vpc.student_app_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_az1.id
}
output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
}
