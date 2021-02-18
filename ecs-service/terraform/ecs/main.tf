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

resource "aws_default_vpc" "default" {}
resource "aws_default_subnet" "default_az1" {
  availability_zone = "${local.env_vars[terraform.workspace]["aws_region"]}a"
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "${local.env_vars[terraform.workspace]["aws_region"]}b"
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  image_version = var.image_version
  registry = var.registry
  subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  vpc_id = aws_default_vpc.default.id
  load_balancer_allowed_cidr_blocks = ["0.0.0.0/0"]
}

# Handle file outputs
resource "local_file" "output" {
  content  = <<EOF
AWS_ACCOUNT_ID="${data.aws_caller_identity.current.account_id}"
AWS_REGION="${local.env_vars[terraform.workspace]["aws_region"]}"
PUBLIC_ENDPOINT="${module.ecs_cluster.load_balancer_endpoint}"
EOF
  filename = "terraform_out"
  file_permission = "0744"
}