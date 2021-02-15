terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.env_vars[terraform.workspace]
}

# S3 bucket
resource "aws_s3_bucket" "website" {
  bucket = "${terraform.workspace}.${local.project}.${local.stack}.bucket"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}