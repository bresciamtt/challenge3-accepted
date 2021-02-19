locals {
  project = "challenge3"
  stack = "ecs-website"
  env_vars = {
    dev = {
      aws_region = "eu-central-1"
    },
    prd = {
      aws_region = "eu-central-1"
    }
  }
}
