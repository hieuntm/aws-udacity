provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "udacity_t2" {
  count         = 4
  ami           = "ami-0182f373e66f89c85"  
  instance_type = "t2.micro"
  tags = {
    Name = "Udacity T2"
  }
}

resource "aws_instance" "udacity_m4" {
  count         = 0
  ami           = "ami-0182f373e66f89c85"  
  instance_type = "m4.large"

  tags = {
    Name = "Udacity M4"
  }
}