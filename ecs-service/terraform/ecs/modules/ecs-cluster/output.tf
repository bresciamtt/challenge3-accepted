output "load_balancer_endpoint" {
  value = "http://${aws_elb.load_balancer.dns_name}"
}