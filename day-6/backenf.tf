terraform {
  backend "s3" {
    bucket         = "chinudevops"
    key            = "dev_1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock-dynamo"  # DynamoDB table used for state locking
    encrypt        = true  # Ensures the state is encrypted at rest in S3
  }
}