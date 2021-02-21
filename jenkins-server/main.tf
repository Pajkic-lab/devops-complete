provider "aws" {
  region     = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "project1-jenkins-terraform-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_vpc" "jenkins-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "jenkins-server-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.jenkins-vpc.id
}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.jenkins-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "jenkins-route-tabel"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.jenkins-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"                        

  tags = {
    Name = "jenkins-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.jenkins-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "jenkins-web"
  }
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.gw ]

  tags = {
    Name = "jenkins-eip"
  }
}

resource "aws_instance" "web-server-instance" {
  ami               = "ami-0932440befd74cdba"
  instance_type     = "t2.medium"
  availability_zone = "eu-central-1a"
  key_name = "test1"                                         

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  tags = {
     Name = "jenkins-server-p1"
   }
}

output "web-server_instance_ip_addr" {
  value = aws_eip.one.public_ip
}

