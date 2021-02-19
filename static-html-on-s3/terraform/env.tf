locals {
  project = "challenge3"
  stack = "static-website"
  env_vars = {
    dev = {
      aws_region = "eu-central-1"
    },
    prd = {
      aws_region = "eu-west-1"
    }
  }
}
