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
#If we want to create or destroy specific resource in terraform configuration file we can use target resource block examplebelow
#terraform apply --target=aws_s3_bucket.dependent
#terraform destroy --target=aws_s3_bucket.dependent