#--------------create vpc --------------------
resource "aws_vpc" "name1" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "custom"
  }
}
#----------------------create ig and attach vpc-----------------
  resource "aws_internet_gateway" "name2" {
  vpc_id = aws_vpc.name1.id

  tags = {
    Name = "cust IG"
  }
}
#------------------------create sunbet-----------------------------

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.name1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pub1"
  }
}

resource "aws_subnet" "main2" {
  vpc_id     =aws_vpc.name1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pub2"
  }
}

resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.name1.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pub3"
  }
}
#------------------route table and attach to--------------------
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.name1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name2.id
  }

  tags = {
    Name = "cust RT"
  }
}
#--------------------subnet association and subnet into rt-------------------
resource "aws_route_table_association" "custom" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.example.id
}

#--------------------s group----------------------------------
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.name1.id

  tags = {
    Name = "SG"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = [var.cidr]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr]
    
  }


}
# -------------ec2 instance --------------------
resource "aws_instance" "web1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name

  tags = {
    Name = "first"
  }
}