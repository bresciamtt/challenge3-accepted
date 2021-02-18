locals {
  project = "challenge3"
  stack = "ecs-website"
  env_vars = {
    development = {
      aws_region = "eu-central-1"
    },
    production = {
      aws_region = "eu-central-1"
    }
  }
}
