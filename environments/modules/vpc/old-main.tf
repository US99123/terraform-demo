
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.67"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   access_key = "${var.access_key}"
#   secret_key = "${var.secret_key}"	
#   region = "${var.region}"
# }

# resource "aws_vpc" "vpc-dev" {                # Creating VPC here
#    cidr_block       = "10.0.0.0/18"     # Defining the CIDR block use 10.0.0.0/18 for demo
#    instance_tenancy = "default"

#    tags = {
#     Name = "vpc-dev"
#    }
#  }

# resource "aws_internet_gateway" "igw-dev" {    # Creating Internet Gateway
#     vpc_id =  aws_vpc.vpc-dev.id               # vpc_id will be generated after we create VPC
#     tags = {
#     Name = "igw-dev"
#   }
#  }

# resource "aws_route_table" "classRT" {
#   vpc_id = aws_vpc.vpc-dev.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw-dev.id
#   }
# }


#  resource "aws_subnet" "publicsubnet-dev" {    # Creating Public Subnets
#    vpc_id =  aws_vpc.vpc-dev.id
#    cidr_block = "10.0.1.0/24"         # CIDR block of public subnets
#    availability_zone = "us-east-1a"
#    tags = {
#     Name = "publicsubnet-dev"
#    }
#  }

#  resource "aws_subnet" "publicsubnet1-dev" {
#    vpc_id =  aws_vpc.vpc-dev.id
#    cidr_block = "10.0.2.0/24"          # CIDR block of private subnets
#    availability_zone = "us-east-1b"
#    tags = {
#     Name = "publicsubnet1-dev"
#   }
#  }

# resource "aws_subnet" "privatesubnet-dev" {
#   vpc_id            = aws_vpc.vpc-dev.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "us-east-1c"

#   tags = {
#     Name = "privatesubnet-dev"
#   }
# }

# resource "aws_subnet" "privatesubnet1-dev" {
#   vpc_id            = aws_vpc.vpc-dev.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = "us-east-1d"

#   tags = {
#     Name = "privatesubnet1-dev"
#   }
# }

# # Associate public subnets with the route table
# resource "aws_route_table_association" "publicasn-dev" {
#   subnet_id      = aws_subnet.publicsubnet-dev.id
#   route_table_id = aws_route_table.classRT.id
# }

# resource "aws_route_table_association" "publicasn1-dev" {
#   subnet_id      = aws_subnet.publicsubnet1-dev.id
#   route_table_id = aws_route_table.classRT.id
# }

# # Create network interfaces
# resource "aws_network_interface" "class_NI" {
#   subnet_id       = aws_subnet.publicsubnet-dev.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.dev-sg.id]
# }

# resource "aws_network_interface" "main-NIC" {
#   subnet_id       = aws_subnet.publicsubnet1-dev.id
#   private_ips     = ["10.0.2.20"]
#   security_groups = [aws_security_group.dev-sg.id]
# }

# # # Create Elastic IPs
# # resource "aws_eip" "class_EIP" {
# #   # vpc                       = true
# #   network_interface         = aws_network_interface.class_NI.id
# #   associate_with_private_ip = "10.0.1.50"
# # }

# # resource "aws_eip" "class_EIP1" {
# #   # vpc                       = true
# #   network_interface         = aws_network_interface.main-NIC.id
# #   associate_with_private_ip = "10.0.2.20"
# # }

# # resource "aws_instance" "class_instance" {
# #   ami           = "ami-0c101f26f147fa7fd"
# #   instance_type = "t2.micro"
# #   key_name      = "demo-keypair"
# #   network_interface {
# #     network_interface_id = aws_network_interface.class_NI.id
# #     device_index         = 0
# #   }

# #   tags = {
# #     Name = "hello1"
# #   }
# # }

# # Create a security group
# resource "aws_security_group" "dev-sg" {
#   name        = "dev-sg"
#   description = "Allow SSH, HTTP, HTTPS inbound traffic"
#   vpc_id      = aws_vpc.vpc-dev.id

#   ingress {
#     description = "SSH from VPC"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTP from VPC"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#      from_port   = 0
#      to_port     = 0
#      protocol    = "-1"
#      cidr_blocks = ["0.0.0.0/0"]
#    }

#   tags = {
#     Name = "dev-sg"
#   }
# }



###################################################################################
###########ABOVE CODE WAS TERRAFORM,NOW MOVED TO TERRAGRUNT########################
###################################################################################