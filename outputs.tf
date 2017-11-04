output "cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "service_role_id" {
  value = "${module.iam.service_role_id}"
}
