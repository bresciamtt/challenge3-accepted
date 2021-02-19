## ECS Cluster provisioning module
# ECS cluster
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name = "${terraform.workspace}-${var.project}-${var.stack}-cluster"
}

# ECS task definition
resource "aws_ecs_task_definition" "task" {
  family = "${terraform.workspace}-${var.project}-${var.stack}-task"
  container_definitions = templatefile(
    "${path.module}/template/task-definition.json",
    {
      task_name = "${terraform.workspace}-${var.project}-${var.stack}-task",
      registry = var.registry,
      image_version = var.image_version,
      cpu = var.ecs_task_cpu
      memory = var.ecs_task_memory
      container_port = var.ecs_task_port
      host_port = var.ecs_task_port
    }
  )
}

# ECS service
resource "aws_ecs_service" "service" {
  name = "${terraform.workspace}-${var.project}-${var.stack}-service"
  cluster = module.ecs.this_ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = var.ecs_service_desired_count
  deployment_maximum_percent = var.ecs_service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent
}
