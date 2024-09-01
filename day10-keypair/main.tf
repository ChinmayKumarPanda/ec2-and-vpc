provider "aws" {
  region = "ap-south-1"  # Specify the region
}

# AWS Key Pair resource
resource "aws_key_pair" "my_key" {
  key_name   = "projectkey"
  public_key = file("C:/Users/Chinmay/Downloads/.ssh/id_rsa.pub")  # Use the full absolute path to the public key file
}

# EC2 Instance resource
resource "aws_instance" "dev" {
  ami           = "ami-02b49a24cfb95941c"  # Confirm this AMI ID is valid in the ap-south-1 region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  user_data     = file("test.sh")  # Ensure this script exists and is correct

  tags = {
    Name = "my_ec2"
  }
}
