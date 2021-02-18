variable "project" {
  description = "The project name"
  type = string
  default = "challenge3"
}

variable "stack" {
  description = "The provisioned stack id"
  type = string
  default = "ecs-website"
}

variable "registry" {
  description = "Registry used by ECS to pull the image. If the image is hosted on docker.hub you can specify the image name only."
  type = string
}

variable "image_version" {
  description = "Version of the image used by ECS."
  type = string
}

variable "ecs_task_cpu" {
  description = "CPU units assigned to the ECS task. Must not be higher than the cluster EC2 cpu units."
  type = number
  default = 512
}

variable "ecs_task_memory" {
  description = "RAM memory (MB) assigned to the ECS task. Must not be higher than the cluster EC2 memory."
  type = number
  default = 512
}

variable "ecs_task_port" {
  description = "The ECS task exposed port"
  type = number
  default = 3000
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type = number
  default = 1
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type = number
  default = 100
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type = number
  default = 0
}

variable "ssh_access_enabled" {
  description = "Whether the SSH access to the cluster EC2s must be enabled"
  type = bool
  default = false
}

variable "asg_instance_type" {
  description = "Instance Type used by ASG to provision the EC2s. Let's keep it in the free-tier by default!"
  type = string
  default = "t2.micro"
}

variable "asg_desired_capacity" {
  description = "Number of EC2 provisioned by the ASG"
  type = number
  default = 1
}

variable "asg_max_size" {
  description = "Max number of EC2 provisioned by the ASG if scaling out"
  type = number
  default = 1
}

variable "asg_min_size" {
  description = "Minimum number of EC2 provisioned by the ASG if scaling in"
  type = number
  default = 1
}

variable "vpc_id" {
  description = "ID of the VPC used by the cluster"
  type = string
}

variable "subnet_ids" {
  description = "List of subnets used by the cluster. At least 2!"
  type = list(string)
}

variable "load_balancer_allowed_cidr_blocks" {
  description = "List of source CIDR blocks allowed on the Load Balancer inbound rule"
  type = list(string)
}

variable "ssh_allowed_cidr_blocks" {
  description = "List of source CIDR blocks allowed on the SSH inbound rule for the cluster EC2s"
  type = list(string)
  default = []
}

variable "ssh_allowed_security_groups" {
  description = "List of security groups allowed on the SSH inbound rule for the cluster EC2s"
  type = list(string)
  default = []
}




