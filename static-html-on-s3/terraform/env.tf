locals {
  project = "challenge3"
  stack = "static-website"
  env_vars = {
    development = {
      aws_region = "eu-central-1"
    },
    production = {
      aws_region = "eu-west-1"
    }
  }
}
