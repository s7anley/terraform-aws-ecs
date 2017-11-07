locals {
  # only create new instance profile and service role if they are not configured
  create_profile        = "${var.instance_profile == "" ? 1 : 0}"
  create_service_role   = "${var.service_role == "" ? 1 : 0}"
  create_autoscale_role = "${var.autoscale_role == "" ? 1 : 0}"
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.instance_role_name}"
  assume_role_policy = "${file("${path.module}/policy/instance-role.json")}"

  count = "${local.create_profile}"
}

resource "aws_iam_policy_attachment" "instance_role_policy" {
  name       = "${var.instance_role_name}-policy"
  roles      = ["${aws_iam_role.instance_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  count      = "${local.create_profile}"
  depends_on = ["aws_iam_role.instance_role"]
}

resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "${var.instance_role_name}-profile"
  path = "/"
  role = "${aws_iam_role.instance_role.name}"

  count = "${local.create_profile}"
}

data "aws_iam_role" "service_role" {
  name = "${service_role}"

  count = "${local.create_service_role ? 0 : 1}"
}

resource "aws_iam_role" "service_role" {
  name               = "${var.service_role_name}"
  assume_role_policy = "${file("${path.module}/policy/service-role.json")}"

  count = "${local.create_service_role}"
}

resource "aws_iam_policy_attachment" "service_role_policy" {
  name       = "${var.service_role_name}-policy"
  roles      = ["${aws_iam_role.service_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"

  count      = "${local.create_service_role}"
  depends_on = ["aws_iam_role.service_role"]
}

data "aws_iam_role" "autoscale_role" {
  name = "${autoscale_role}"

  count = "${local.create_autoscale_role ? 0 : 1}"
}

resource "aws_iam_role" "autoscale_role" {
  name               = "${var.autoscale_role_name}"
  assume_role_policy = "${file("${path.module}/policy/autoscale-role.json")}"

  count = "${local.create_autoscale_role}"
}

resource "aws_iam_policy_attachment" "autoscale_role_policy" {
  name       = "${var.autoscale_role_name}-policy"
  roles      = ["${aws_iam_role.autoscale_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"

  count      = "${local.create_autoscale_role}"
  depends_on = ["aws_iam_role.autoscale_role"]
}
