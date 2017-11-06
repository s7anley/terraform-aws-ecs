output "task_id" {
  value = "${aws_ecs_task_definition.default.id}"
}

output "task_family" {
  value = "${aws_ecs_task_definition.default.family}"
}

output "task_revision" {
  value = "${aws_ecs_task_definition.default.revision}"
}
