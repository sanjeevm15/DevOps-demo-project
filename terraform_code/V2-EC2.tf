provider "aws" {
  region = "us-west-1"
}
resource "aws_instance" "demo-server" {
  ami = "ami-04fdea8e25817cd69"
  instance_type = "t2.micro"
  key_name = "demokey"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "ssh access"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}

