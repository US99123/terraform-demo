terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"	
  region = "${var.region}"
}

# provider "aws" {
# access_key = "${var.access_key}"
# secret_key = "${var.secret_key}"
# region = "${var.region}"
# }

resource "aws_vpc" "vpc-demo" {                # Creating VPC here
   cidr_block       = "10.0.0.0/18"     # Defining the CIDR block use 10.0.0.0/18 for demo
   instance_tenancy = "dedicated"

   tags = {
    Name = "vpc-demo"
  }

 }

resource "aws_internet_gateway" "igw-demo" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.vpc-demo.id               # vpc_id will be generated after we create VPC
    tags = {
    Name = "igw-demo"
  }

 }

 resource "aws_subnet" "publicsubnet-demo" {    # Creating Public Subnets
   vpc_id =  aws_vpc.vpc-demo.id
   cidr_block = "10.0.0.0/24"         # CIDR block of public subnets
   availability_zone = "us-east-1e"
   tags = {
    Name = "publicsubnet-demo"
  }
 }

 resource "aws_subnet" "privatesubnet-demo" {
   vpc_id =  aws_vpc.vpc-demo.id
   cidr_block = "10.0.1.0/24"          # CIDR block of private subnets
   availability_zone = "us-east-1a"
   tags = {
    Name = "privatesubnet-demo"
  }
 }

resource "aws_route_table" "PublicRT-demo" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.vpc-demo.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw-demo.id
     }
    tags = {
    Name = "PublicRT-demo"
  }

 }

 resource "aws_route_table" "PrivateRT-demo" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.vpc-demo.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw-demo.id
   }
      tags = {
    Name = "PrivateRT-demo"
  }

 }

 resource "aws_eip" "nateIP-demo" {
   vpc   = true
      tags = {
    Name = "nateIP-demo"
  }

 }

 resource "aws_nat_gateway" "NATgw-demo" {
   allocation_id = aws_eip.nateIP-demo.id
   subnet_id = aws_subnet.publicsubnet-demo.id
 }

#  Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation-demo" {
    subnet_id = aws_subnet.publicsubnet-demo.id
    route_table_id = aws_route_table.PublicRT-demo.id
 }

#  Route table Association with Private Subnet's
 resource "aws_route_table_association" "PrivateRTassociation-demo" {
    subnet_id = aws_subnet.privatesubnet-demo.id
    route_table_id = aws_route_table.PrivateRT-demo.id
 }

#below is working
# resource "aws_instance" "amz-lnx2-demo" {
#   ami           = "ami-0aa7d40eeae50c9a9"
#   instance_type = "t2.micro"

#   credit_specification {
#     cpu_credits = "unlimited"
#   }

#    tags = {
#     Name = "amz-lnx2-demo"
#   }
# }

# resource "aws_ebs_volume" "amz-lnx2-demo-vol" {
#   availability_zone = "us-east-1a"
#   size              = 8

#   tags = {
#     Name = "amz-lnx2-demo-vol"
#   }  
# }

#below code has issue
# data "aws_ebs_volume" "amz-lnx2-demo-vol" {
#     most_recent = true

#     filter {
#       name   = "volume-type"
#       values = ["standard"]
#     }

#     filter {
#       name   = "tag:Name"
#       values = ["amz-lnx2-demo-vol"]
#     }
# }


resource "aws_security_group" "secgrp-demo" {
 name        = "secgrp-demo"
 description = "Allow standard http and https ports inbound and everything outbound"
 vpc_id      = aws_vpc.vpc-demo.id

 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
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
   "Terraform" : "true"
   "Name" : "secgrp-demo"
 }
}

# resource "aws_elb" "lb-demo" {
#   name            = "lb-demo"
#   internal        = false
#   # load_balancer_type = "application"
#   security_groups    = [aws_security_group.secgrp-demo.id]
#   idle_timeout       = 60
#   subnets            = [for subnet in aws_subnet.publicsubnet-demo : publicsubnet-demo.id]
#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#   tags = {
#     "Terraform" : "true"
#   }
# }