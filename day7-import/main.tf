resource "aws_instance" "dev" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"
  key_name      ="projectkey"
  tags = {
    Name = "my ec2"
  }
}