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

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name = "${terraform.workspace}-${local.project}-${local.stack}-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family = "${terraform.workspace}-${local.project}-${local.stack}-task"
  container_definitions = templatefile(
    "${path.module}/template/task-definition.json",
    {
      task_name = "${terraform.workspace}-${local.project}-${local.stack}-task",
      registry = var.registry,
      image_version = var.image_version,
      cpu = local.env_vars[terraform.workspace]["ecs_task_cpu"]
      memory = local.env_vars[terraform.workspace]["ecs_task_memory"]
      container_port = local.env_vars[terraform.workspace]["ecs_task_port"]
      host_port = local.env_vars[terraform.workspace]["ecs_task_port"]
    }
  )
}

resource "aws_ecs_service" "service" {
  name = "${terraform.workspace}-${local.project}-${local.stack}-service"
  cluster = module.ecs.this_ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = local.env_vars[terraform.workspace]["ecs_service_desired_count"]
  deployment_maximum_percent = local.env_vars[terraform.workspace]["ecs_service_deployment_maximum_percent"]
  deployment_minimum_healthy_percent = local.env_vars[terraform.workspace]["ecs_service_deployment_minimum_healthy_percent"]
}

resource "aws_security_group" "task_sg" {
  name = "${terraform.workspace}-${local.project}-${local.stack}-task-sg"
  description = "Allow inbound from load balancer"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = local.env_vars[terraform.workspace]["ecs_task_port"]
    to_port = local.env_vars[terraform.workspace]["ecs_task_port"]
    protocol = "TCP"
    security_groups = []
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "task_ssh_sg" {
  count = local.env_vars[terraform.workspace]["ssh_access_enabled"] ? 1 : 0
  name = "${terraform.workspace}-${local.project}-${local.stack}-task-sg"
  description = "Allow ssh inbound"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = local.env_vars[terraform.workspace]["ssh_allowed_cidr_blocks"]
    security_groups = local.env_vars[terraform.workspace]["ssh_allowed_security_groups"]
  }
}

module "autoscaling_group" {
  source = "terraform-aws-modules/autoscaling/aws"
  name = "${terraform.workspace}-${local.project}-${local.stack}-asg"

  lc_name = "${terraform.workspace}-${local.project}-${local.stack}-lc"

  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = local.env_vars[terraform.workspace]["asg_instance_type"]
  security_groups = local.env_vars[terraform.workspace]["ssh_access_enabled"] ? [aws_security_group.task_ssh_sg.id, aws_security_group.task_sg.id] : [aws_security_group.task_sg.id]

  user_data = templatefile("${path.module}/template/user-data.sh", { cluster_id = module.ecs.this_ecs_cluster_id })

  asg_name = "${terraform.workspace}-${local.project}-${local.stack}-asg"
  desired_capacity = local.env_vars[terraform.workspace]["asg_desired_capacity"]
  health_check_type = "EC2"
  max_size = local.env_vars[terraform.workspace]["asg_max_size"]
  min_size = local.env_vars[terraform.workspace]["asg_min_size"]

  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  recreate_asg_when_lc_changes = true
  load_balancers = []
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

# Handle file outputs
resource "local_file" "output" {
  content  = <<EOF
AWS_ACCOUNT_ID="${data.aws_caller_identity.current.account_id}"
AWS_REGION="${local.env_vars[terraform.workspace]["aws_region"]}"
EOF
  filename = "terraform_out"
  file_permission = "0744"
}