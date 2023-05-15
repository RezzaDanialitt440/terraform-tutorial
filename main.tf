terraform {

  backend "s3" {
    profile = "default"
    bucket = "terraform-tutorial-tf-state-rezzadanialcs"
    key = "terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "terraform-tutorial-tf-state-rezzadanialcs"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf-state-versioning" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state-bucket-sse" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf-table" {
  name           = "terraform-state-locking"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
