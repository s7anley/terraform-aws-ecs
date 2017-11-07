locals {
  is_scale_out = "${var.scale_type == "out"}"

  name_sufix = "${local.is_scale_out ? "scale-out-alarm" : "scale-in-alarm"}"
  comparison = "${local.is_scale_out ? "GreaterThanOrEqualToThreshold" : "LessThanOrEqualToThreshold"}"
}

resource "aws_cloudwatch_metric_alarm" "scale_cluster_alarm" {
  alarm_name          = "ecs-cluster-${var.cluster_name}-${local.name_sufix}"
  comparison_operator = "${local.comparison}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "AWS/ECS"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = ["${var.policy_arn}"]

  count = "${var.enable ? 1 : 0}"
}
