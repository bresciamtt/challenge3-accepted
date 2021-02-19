locals {
  project = "challenge3"
  stack = "static-website"
  env_vars = {
    dev = {
      aws_region = "eu-central-1",
      blacklisted_ips = [
        "80.82.65.47/32"
      ]
    },
    prd = {
      aws_region = "eu-central-1",
      blacklisted_ips = [
        "94.102.53.112/32",
        "80.82.65.47/32"
      ]
    }
  }
}
