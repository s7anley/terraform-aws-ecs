resource "aws_iam_role" "instance_role" {
  name               = "${var.instance_role_name}"
  assume_role_policy = "${file("${path.module}/policy/instance-role.json")}"

  count = "${var.skip_instance_role ? 0 : 1}"
}

resource "aws_iam_policy_attachment" "instance_role_policy" {
  name       = "${var.instance_role_name}-policy"
  roles      = ["${aws_iam_role.instance_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  count      = "${var.skip_instance_role ? 0 : 1}"
  depends_on = ["aws_iam_role.instance_role"]
}

resource "aws_iam_instance_profile" "instance_role_profile" {
  name = "${var.instance_role_name}-profile"
  path = "/"
  role = "${aws_iam_role.instance_role.name}"

  count = "${var.skip_instance_role ? 0 : 1}"
}

resource "aws_iam_role" "load_balancing_role" {
  name               = "${var.load_balancing_role_name}"
  assume_role_policy = "${file("${path.module}/policy/load-balancing-role.json")}"

  count = "${var.skip_load_balancing_role ? 0 : 1}"
}

resource "aws_iam_policy_attachment" "load_balancing_role_policy" {
  name       = "${var.load_balancing_role_name}-policy"
  roles      = ["${aws_iam_role.load_balancing_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"

  count      = "${var.skip_load_balancing_role ? 0 : 1}"
  depends_on = ["aws_iam_role.load_balancing_role"]
}

resource "aws_iam_role" "autoscale_role" {
  name               = "${var.autoscale_role_name}"
  assume_role_policy = "${file("${path.module}/policy/autoscale-role.json")}"

  count = "${var.skip_autoscale_role ? 0 : 1}"
}

resource "aws_iam_policy_attachment" "autoscale_role_policy" {
  name       = "${var.autoscale_role_name}-policy"
  roles      = ["${aws_iam_role.autoscale_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"

  count      = "${var.skip_autoscale_role ? 0 : 1}"
  depends_on = ["aws_iam_role.autoscale_role"]
}
