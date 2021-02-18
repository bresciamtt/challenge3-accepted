# AutoScaling group used by ECS to host the tasks
module "autoscaling_group" {
  source = "terraform-aws-modules/autoscaling/aws"
  name = "${terraform.workspace}-${var.project}-${var.stack}-asg"

  lc_name = "${terraform.workspace}-${var.project}-${var.stack}-lc"

  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = var.asg_instance_type
  security_groups = var.ssh_access_enabled ? [aws_security_group.task_ssh_sg[0].id, aws_security_group.task_sg.id] : [aws_security_group.task_sg.id]

  user_data = templatefile("${path.module}/template/user-data.sh", { cluster_id = module.ecs.this_ecs_cluster_id })

  iam_instance_profile = aws_iam_instance_profile.asg_profile.id
  asg_name = "${terraform.workspace}-${var.project}-${var.stack}-asg"
  desired_capacity = var.asg_desired_capacity
  health_check_type = "EC2"
  max_size = var.asg_max_size
  min_size = var.asg_min_size

  vpc_zone_identifier = var.subnet_ids

  recreate_asg_when_lc_changes = true
  load_balancers = [aws_elb.load_balancer.id]
}

# AMI used by the ASG to provision the cluster EC2s
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