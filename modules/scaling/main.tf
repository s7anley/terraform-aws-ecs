locals {
  autoscale_count = "${var.enable ? 1 : 0}"
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "ecs-cluster-${var.cluster_name}-scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${var.scale_out_cooldown}"
  autoscaling_group_name = "${var.autoscaling_group_name}"

  count = "${local.autoscale_count}"
}

module "scale_out_alarm" {
  source = "../alarm"

  enable             = "${local.autoscale_count}"
  cluster_name       = "${var.cluster_name}"
  period             = "${var.scale_out_period}"
  evaluation_periods = "${var.scale_out_evaluation_periods}"
  statistic          = "${var.scale_out_statistic}"
  threshold          = "${var.scale_out_threshold}"
  policy_arn         = "${join("", aws_autoscaling_policy.scale_out_policy.*.arn)}"
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "ecs-cluster-${var.cluster_name}-scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${var.scale_in_cooldown}"
  autoscaling_group_name = "${var.autoscaling_group_name}"

  count = "${local.autoscale_count}"
}

module "scale_in_alarm" {
  source = "../alarm"

  enable             = "${local.autoscale_count}"
  scale_type         = "in"
  cluster_name       = "${var.cluster_name}"
  period             = "${var.scale_in_period}"
  evaluation_periods = "${var.scale_in_evaluation_periods}"
  statistic          = "${var.scale_in_statistic}"
  threshold          = "${var.scale_in_threshold}"
  policy_arn         = "${join("", aws_autoscaling_policy.scale_in_policy.*.arn)}"
}
