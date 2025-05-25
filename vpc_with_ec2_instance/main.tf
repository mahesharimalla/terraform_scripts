resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}


resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-subnet-1"
  }

}


resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-subnet-2"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "terraform-igw"                # Always wrap tag values (or any plain text) in double quotes.
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "terraform-rt"                # Always wrap tag values (or any plain text) in double quotes.
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_security_group" "terraform-sg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress  {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress  {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "webserver1" {
  ami                    = "ami-0f9de6e2d2f067fca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data = file("setup.sh")
  #user_data              = base64encode(file("setup.sh"))
  tags = {
    Name = "weblogin-server"                # Always wrap tag values (or any plain text) in double quotes.
  }
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-0f9de6e2d2f067fca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data = file("ecomm-setup.sh")
  #user_data              = base64encode(file("ecomm-setup.sh"))
  
  tags = {
    Name = "Ecomm-server"                # Always wrap tag values (or any plain text) in double quotes.
  }
}







