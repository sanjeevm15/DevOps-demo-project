
provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-04fdea8e25817cd69"
  instance_type = "t2.micro"
  key_name = "demokey"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id = aws_subnet.dpw-public_subnet_01.id
# Adding 3 servers jenkins master for CI/CD, build slave for maven and docker and ansible master for configuration
  for_each = toset(["Jenkins-master", "Build-slave", "Ansible"])
   tags = {
     Name = "${each.key}"
   }
}


resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "ssh access"
  vpc_id =aws_vpc.dpw-vpc.id

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

### 1. Create VPC

     resource "aws_vpc" "dpw-vpc" {
          cidr_block = "10.1.0.0/16"
          tags = {
           Name = "dpw-vpc"
        }
      }
  
### 2. Create Subnet - 2 public subnets

resource "aws_subnet" "dpw-public_subnet_01" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
      Name = "dpw-public_subent_01"
    }
}

resource "aws_subnet" "dpw-public_subnet_02" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1c"
    tags = {
      Name = "dpw-public_subent_02"
    }
}

### 3. Create Internet Gateway
 
resource "aws_internet_gateway" "dpw-igw" {
    vpc_id = aws_vpc.dpw-vpc.id
    tags = {
      Name = "dpw-igw"
    }
}

#### 4. Create route table 

resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.dpw-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpw-igw.id
    }
    tags = {
      Name = "dpw-public-rt"
    }
}

# 5. Route table association for 2 subnets


resource "aws_route_table_association" "dpw-rta-public-subent-1" {
    subnet_id = aws_subnet.dpw-public_subnet_01.id
    route_table_id = aws_route_table.dpw-public-rt.id
}

resource "aws_route_table_association" "dpw-rta-public-subent-2" {
    subnet_id = aws_subnet.dpw-public_subnet_02.id
    route_table_id = aws_route_table.dpw-public-rt.id
}


