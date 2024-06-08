output "vpc_name" {
  value = aws_vpc.sat_vpc.id
}

output "intance_id" {
  value = aws_instance.luc_instance.public_ip
}