provider "aws" {
  region = "us-west-1"
}
resource "aws_instance" "demo-server" {
  ami = "ami-04fdea8e25817cd69"
  instance_type = "t2.micro"
  key_name = "demokey"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  
}



