output "instance_role_id" {
  value = "${join("", aws_iam_role.instance_role.*.id)}"
}

output "instance_role_name" {
  value = "${join("", aws_iam_role.instance_role.*.name)}"
}

output "instance_profile_name" {
  value = "${join("", aws_iam_instance_profile.instance_role_profile.*.name)}"
}

output "load_balancing_role_id" {
  value = "${join("", aws_iam_role.load_balancing_role.*.id)}"
}

output "load_balancing_role_name" {
  value = "${join("", aws_iam_role.load_balancing_role.*.name)}"
}

output "autoscale_role_id" {
  value = "${join("", aws_iam_role.autoscale_role.*.id)}"
}

output "autoscale_role_name" {
  value = "${join("", aws_iam_role.autoscale_role.*.name)}"
}
