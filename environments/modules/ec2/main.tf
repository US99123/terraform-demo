provider "aws" {
  region = "us-east-1"
  
}

resource "aws_instance" "test" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"

  tags = {
    Name = "terragrunt-dev"
  }
}
