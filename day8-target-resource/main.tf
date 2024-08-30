resource "aws_instance" "dev" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"
  key_name      = "projectkey"
 
  tags = {
    name = "chinu"
  }
}
resource "aws_s3_bucket" "web" {
  bucket = "chinudevops"

  tags = {
    Name = "My bucket"
  }
}