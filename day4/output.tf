output "publicip" {
  value = aws_instance.web1.public_ip
}

output "privateip" {
  value = aws_instance.web1.private_ip
  sensitive = true
}
