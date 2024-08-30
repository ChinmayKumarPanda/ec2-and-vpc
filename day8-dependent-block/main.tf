#------------------------ EC2 Instance----------------
resource "aws_instance" "dev" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"
  key_name      = "projectkey"
 
  tags = {
    Name = "chinu"
  }
}

# -----------------------S3 Bucket----------------------
resource "aws_s3_bucket" "web" {
  bucket = "chinudevops"

  # Depends on the EC2 instance
  depends_on = [aws_instance.dev]
  
  tags = {
    Name = "chinu-web-bucket"
   
  }
}