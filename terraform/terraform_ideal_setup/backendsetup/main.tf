terraform {
  required_version = ">=1.2.0"
}

provider "aws" {
  region = "us-east-2"
}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id

}
# S3bucket for Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.account_id}-demoterraform-states"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default { sse_algorithm = "AES256" }

      }

   }

}

# DynamoDB table for state locking

resource "aws_dynamodb_table" "demoterraform_lock" {
  name         = "demoterraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"

  }

}
