output "cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "load_balancing_role_id" {
  value = "${module.iam.load_balancing_role_id}"
}

output "load_balancing_role_name" {
  value = "${module.iam.load_balancing_role_name}"
}

output "autoscale_role_id" {
  value = "${module.iam.autoscale_role_id}"
}

output "autoscale_role_name" {
  value = "${module.iam.autoscale_role_name}"
}
