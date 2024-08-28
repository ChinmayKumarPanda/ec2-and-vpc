# Output the EC2 Public IP
output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web1.public_ip
}

# Output the EC2 Private IP
output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.web1.private_ip
  sensitive   = true
}


