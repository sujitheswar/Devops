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
  region  = "us-east-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-id"
  instance_type = "t3.micro"
  key_name      = "okeynam9"
  subnet_id     ="subnet-id"
  associate_public_ip_address = true

  tags = {
    Name = "Terraform_Demo"
  }
}

