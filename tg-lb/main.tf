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

resource "aws_subnet" "main4" {
  vpc_id     = aws_vpc.name1.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pri1"
  }
}
resource "aws_subnet" "main5" {
  vpc_id     = aws_vpc.name1.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pri2"
  }
  }
#---------------------NAT gateway--------------
resource "aws_eip" "custom" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}
resource "aws_nat_gateway" "example3" {
  allocation_id = aws_eip.custom.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "gw NAT"
  }
}
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.name1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example3.id
  }

  tags = {
    Name = "priv RT"
  }
}
#------------------route table and attach to--------------------
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.name1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name2.id
  }

  tags = {
    Name = "pub RT"
  }
}


#--------------------subnet association and subnet into rt-------------------


# Assign `aws_route_table.example` to a public subnet
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.public_route.id
}

# Assign `aws_route_table.private_route` to the private subnet
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.main4.id
  route_table_id = aws_route_table.private_route.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.main5.id
  route_table_id = aws_route_table.private_route.id
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
  description      = "Allow HTTP from anywhere"
  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  cidr_blocks      = [var.cidr]
}

ingress {
  description      = "Allow SSH from anywhere"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = [var.cidr]
}

egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [var.cidr]
}
}
#-------------LB------------
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.main.id, aws_subnet.main2.id]

  tags = {
    Name = "app-lb"
  }
}
#---------------------TG------------------
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.name1.id

  health_check {
  path                = "/"
  protocol            = "HTTP"
  matcher             = "200"
  interval            = 60  # Ensure the application is ready before the first check
  timeout             = 10  # Increase timeout if necessary
  healthy_threshold   = 5
  unhealthy_threshold = 5
}

  tags = {
    Name = "app-tg"
  }
}

#----------------------Attach the EC2 instance to the target group-----------------------
resource "aws_lb_target_group_attachment" "web1_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}
#---------------------------Listener--------------------
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
# -------------ec2 instance --------------------
resource "aws_instance" "web1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.main.id
  associate_public_ip_address = true
security_groups        = [aws_security_group.allow_tls.id]  # Use ID here
  tags = {
    Name = "first"
  }
}