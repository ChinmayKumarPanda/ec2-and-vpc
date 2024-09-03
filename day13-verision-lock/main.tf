resource "aws_instance" "test" {
    ami = "ami-02b49a24cfb95941c"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "project"
}