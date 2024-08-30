#-----------------------ec2 instance----------------------
resource "aws_instance" "test" {
  ami             = "ami-02b49a24cfb95941c"
  instance_type   = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name        = "projectkey"
  
  tags = {
    Name = "dev_1"
  }
}
#------------------------------s3 bucket---------------------------
resource "aws_s3_bucket" "example" {
  bucket = "chinudevops"

  tags = {
    Name = "My bucket"
  }
}

#------------------locking provision for statefile-----------------
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockId"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name = "TerraformStateLock"
  }
}