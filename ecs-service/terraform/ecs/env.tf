locals {
  project = "challenge3"
  stack = "ecs-website"
  env_vars = {
    dev = {
      aws_region = "eu-central-1",
      nacl_rules = [
        {
          rule_number = 100
          egress = false
          protocol = "all"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 0
          to_port = 0
        },
        {
          rule_number = 100
          egress = true
          protocol = "all"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 0
          to_port = 0
        },
      ],
      website_allowed_cidr_blocks = ["0.0.0.0/0"]
    },
    prd = {
      aws_region = "eu-central-1",
      nacl_rules = [
        {
          rule_number = 100
          egress = false
          protocol = "all"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 0
          to_port = 0
        },
        {
          rule_number = 100
          egress = true
          protocol = "all"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 0
          to_port = 0
        },
      ],
      website_allowed_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
