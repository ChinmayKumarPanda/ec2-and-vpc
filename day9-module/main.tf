module "dev" {
    source = "../day2"
   ami_id = "ami-02b49a24cfb95941c"
 instance_type ="t2.micro"
 key_name ="projectkey"
  
}