terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "account id-demoterraform-states" # same bucket from Step 1
    key            = "ec2-demo/terraform.tfstate"         # path inside S3 bucket
    region         = "us-east-2"
    dynamodb_table = "demoterraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "app_server" {
  ami                         = "ami-0cfde0ea8edd312d4"
  instance_type               = "t3.micro"
  key_name                    = "ohio1309"
  subnet_id                   = "subnet-078043c28e92411d7"
  associate_public_ip_address = true

  tags = {
    Name = "Terraform_2Demo"
  }
}
