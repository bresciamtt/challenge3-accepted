# Security Group attached to the load balancer.
# Used to restrict the public app access.
resource "aws_security_group" "load_balancer_sg" {
  name = "${terraform.workspace}-${var.project}-${var.stack}-lb-sg"
  description = "Allow inbound connections"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = var.load_balancer_allowed_cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group attached to the instance running the ECS task.
# Used to restrict the EC2 direct access.
resource "aws_security_group" "task_sg" {
  name = "${terraform.workspace}-${var.project}-${var.stack}-task-sg"
  description = "Allow inbound from load balancer"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.ecs_task_port
    to_port = var.ecs_task_port
    protocol = "TCP"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group attached to the instance running the ECS task.
# Used to restrict the EC2 SSH inbound rules.
resource "aws_security_group" "task_ssh_sg" {
  count = var.ssh_access_enabled ? 1 : 0
  name = "${terraform.workspace}-${var.project}-${var.stack}-task-ssh-sg"
  description = "Allow ssh inbound"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = var.ssh_allowed_cidr_blocks
    security_groups = var.ssh_allowed_security_groups
  }
}