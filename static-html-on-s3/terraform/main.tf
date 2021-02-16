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
  region = local.env_vars[terraform.workspace]["aws_region"]
}

data "aws_caller_identity" "current" {}

# S3 bucket
resource "aws_s3_bucket" "website" {
  bucket = "${terraform.workspace}.${local.project}.${local.stack}.bucket"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

# Handle file outputs
resource "local_file" "output" {
  content  = <<EOF
S3_BUCKET_NAME="${aws_s3_bucket.website.bucket}"
AWS_ACCOUNT_ID="${data.aws_caller_identity.current.account_id}"
AWS_REGION="${aws_s3_bucket.website.region}"
EOF
  filename = "terraform_out"
  file_permission = "0744"
}