terraform {
    source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=5.6.0"
}


generate "provider" {
path = "provider.tf"
if_exists = "overwrite_terragrunt"
contents = <<EOF
provider "aws" {
profile = "default"
region = "us-east-1"
}
EOF
}


inputs = {
    ami = "ami-0005e0cfe09cc9050"
    instance_type = "t2.micro"
    tags = {
    Name = "grunt-ec2"
    }
}