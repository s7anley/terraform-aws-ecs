output "instance_profile_name" {
  value = "${coalesce(var.instance_profile, join("", aws_iam_instance_profile.instance_role_profile.*.name))}"
}

output "service_role_id" {
  value = "${coalesce(join("", data.aws_iam_role.service_role.*.id), join("", aws_iam_role.service_role.*.id))}"
}

output "service_role_name" {
  value = "${coalesce(var.service_role, join("", aws_iam_role.service_role.*.name))}"
}

output "autoscale_role_id" {
  value = "${coalesce(join("", data.aws_iam_role.autoscale_role.*.id), join("", aws_iam_role.autoscale_role.*.id))}"
}

output "autoscale_role_name" {
  value = "${coalesce(var.autoscale_role, join("", aws_iam_role.autoscale_role.*.name))}"
}

output "autoscale_role_arn" {
  value = "${coalesce(join("", data.aws_iam_role.autoscale_role.*.arn), join("", aws_iam_role.autoscale_role.*.arn))}"
}
