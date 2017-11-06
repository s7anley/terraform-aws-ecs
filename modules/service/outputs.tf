output "service_id" {
  value = "${coalesce(join("", aws_ecs_service.default.*.id), join("", aws_ecs_service.default-alb.*.id))}"
}

output "service_name" {
  value = "${coalesce(join("", aws_ecs_service.default.*.name), join("", aws_ecs_service.default-alb.*.name))}"
}

output "service_endpoint" {
  value = "${join("", aws_alb.default.*.dns_name)}"
}
