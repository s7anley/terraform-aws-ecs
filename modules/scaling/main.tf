locals {
  autoscale_count = "${var.enable ? 1 : 0}"
}

resource "aws_autoscaling_policy" "scaleoutpolicy" {
  name                   = "ecs-cluster-${var.cluster_name}-scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${var.scale_out_cooldown}"
  autoscaling_group_name = "${var.autoscaling_group_name}"

  count = "${local.autoscale_count}"
}

resource "aws_cloudwatch_metric_alarm" "scaleoutalaram" {
  alarm_name          = "ecs-cluster-${var.cluster_name}-scale-out-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.scale_out_evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.scale_out_period}"
  statistic           = "Average"
  threshold           = "${var.scale_out_threshold}"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.scaleoutpolicy.arn}"]

  count = "${local.autoscale_count}"
}

resource "aws_autoscaling_policy" "scaleinpolicy" {
  name                   = "ecs-cluster-${var.cluster_name}-scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "${var.scale_in_cooldown}"
  autoscaling_group_name = "${var.autoscaling_group_name}"

  count = "${local.autoscale_count}"
}

resource "aws_cloudwatch_metric_alarm" "scaleinalaram" {
  alarm_name          = "ecs-cluster-${var.cluster_name}-scale-in-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "${var.scale_in_evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.scale_in_period}"
  statistic           = "Average"
  threshold           = "${var.scale_in_threshold}"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.scaleinpolicy.arn}"]

  count = "${local.autoscale_count}"
}
