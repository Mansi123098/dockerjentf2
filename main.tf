provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "mn23" {
  instance_type = "t2.micro"
  ami           = "ami-0182f373e66f89c85"
  tags = {
    Name = "mn23"
  }
  }
