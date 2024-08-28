variable "cidr" {
 description = "The ID of the AMI to use for the instance"
  type        = string
}

variable "ami" {
 description = "The ID of the AMI to use for the instance"
  type        = string
}


variable "instance_type" {
    description = "passing the value to main.tf"
    type = string
    default = ""
}
variable "key_name" {
    description = "passing the value to main.tf"
    type = string
    default = ""
}
variable "load_balancer_type" {
    description = "passing the value to main.tf"
    type = string
    default = ""
}