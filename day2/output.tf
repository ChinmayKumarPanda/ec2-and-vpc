output "publicip" {
    value = aws_instance.dev2.public_ip
    description = "printing the public ip"
  
  
}
output "privateip" {
    value = aws_instance.dev2.private_ip
    sensitive = true
  
}