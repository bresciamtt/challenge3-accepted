# AWS Elastic Load Balancer
resource "aws_elb" "load_balancer" {
  name = "${terraform.workspace}-${var.project}-${var.stack}-elb"

  listener {
    instance_port = var.ecs_task_port
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  subnets = var.subnet_ids
  internal = false
  security_groups = [aws_security_group.load_balancer_sg.id]
}