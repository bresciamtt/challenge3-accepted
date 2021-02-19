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

resource "aws_ecr_repository" "registry" {
  name                 = "${terraform.workspace}.${local.project}.${local.stack}.registry"
  image_tag_mutability = "MUTABLE"
}

# Handle file outputs
resource "local_file" "output" {
  content  = <<EOF
REGISTRY_ID="${aws_ecr_repository.registry.registry_id}"
REGISTRY_URL="${aws_ecr_repository.registry.repository_url}"
AWS_ACCOUNT_ID="${data.aws_caller_identity.current.account_id}"
AWS_REGION="${local.env_vars[terraform.workspace]["aws_region"]}"
EOF
  filename = "terraform_out"
  file_permission = "0744"
}