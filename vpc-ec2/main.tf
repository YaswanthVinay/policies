//launch an EC2 instance and log in to that instance and check whether the role is wroking as expected or not

#Create EC2 instance and Attach Instance Profile

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.proj_name}-vpc"
  }
}
resource "aws_subnet" "app-sn" {
  count             = length(var.app-sn-cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.app-sn-cidr, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "app Subnet - ${count.index + 1}"
  }
}
resource "aws_subnet" "db-sn" {
  count             = length(var.db-sn-cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.db-sn-cidr, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "db-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "web-sn" {
  count             = length(var.web-sn-cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.web-sn-cidr, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "web-subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW"
  }

}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.igw_cidr
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "public-rt"
  }
}
resource "aws_route_table_association" "associate-web-public-sns" {
  count          = length(var.azs)
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.web-sn[count.index].id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-rt"
  }
}
resource "aws_route_table_association" "associate-app-private-sns" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.app-sn[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "associate-db-private-sns" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.db-sn[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
#creating security groups 
resource "aws_security_group" "web-sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "web layer security group"
  tags = {
    Name = "web-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"]
  # you cam use Either Linux / Ubuntu.. i have added both the filters here(Ubuntu and Amazon Linux)
  # filter {
  #   name   = "name"
  #   values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"]
  # }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "server" {
  count                  = 1
  ami                    = data.aws_ami.ami_name.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web-sn[count.index].id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  #  note: 
  #  here instance profile will be created automatically when using AWS Console,but when using terraform or AWS SDK/CLI you have to explicitly add the instance profile to the iam role.
  # IAM INSTANCE PROFILE is nothing but a container which iam role will be stored.
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  tags = {
    Name = "iam-server- ${count.index + 1}"
  }
}
