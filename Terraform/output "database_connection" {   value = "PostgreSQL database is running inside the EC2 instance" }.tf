# outputs.tf
output "instance_public_ip" {
  value = aws_instance.cloudvision_ec2.public_ip
}

output "database_endpoint" {
  value = aws_db_instance.cloudvision_db.endpoint
}
