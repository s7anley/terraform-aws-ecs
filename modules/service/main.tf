data "aws_ecs_cluster" "default" {
  cluster_name = "${var.cluster_name}"
}

data "aws_iam_role" "default" {
  name  = "${var.service_role}"
  count = "${var.service_role == "" ? 0 : 1}"
}

resource "aws_ecs_service" "default" {
  count = "${var.has_load_balancer ? 0 : 1}"

  name            = "${var.name}"
  cluster         = "${data.aws_ecs_cluster.default.id}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${var.service_role == "" ? "" : .arn}"
  iam_role        = "${coalesce(var.service_role, join("", data.aws_iam_role.default.*.arn))}"

  deployment_maximum_percent         = "${var.max_healthy_percent}"
  deployment_minimum_healthy_percent = "${var.min_healthy_percent}"

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_alb_target_group" "default" {
  count = "${var.has_load_balancer ? 1 : 0}"

  name     = "${var.name}-${var.cluster_name}-tg"
  port     = "${var.alb_port}"
  protocol = "${var.alb_protocol}"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_security_group" "default" {
  count = "${var.has_load_balancer ? 1 : 0}"

  name        = "${var.name}-${var.cluster_name}-alb-sc"
  description = "Allow access to alb on defined port."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.alb_port}"
    to_port     = "${var.alb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "default" {
  count = "${var.has_load_balancer ? 1 : 0}"

  name            = "${var.name}-${var.cluster_name}-alb"
  subnets         = ["${var.alb_subnets}"]
  security_groups = ["${concat(var.alb_security_groups, aws_security_group.default.*.id)}"]
}

resource "aws_alb_listener" "default" {
  count = "${var.has_load_balancer ? 1 : 0}"

  load_balancer_arn = "${aws_alb.default.id}"
  port              = "${var.alb_port}"
  protocol          = "${var.alb_protocol}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_ecs_service" "default-alb" {
  count      = "${var.has_load_balancer ? 1 : 0}"
  depends_on = ["aws_alb.default"]

  name            = "${var.name}"
  cluster         = "${data.aws_ecs_cluster.default.id}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${data.aws_iam_role.default.arn}"

  deployment_maximum_percent         = "${var.max_healthy_percent}"
  deployment_minimum_healthy_percent = "${var.min_healthy_percent}"

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
    target_group_arn = "${aws_alb_target_group.default.id}"
  }
}

# Autoscaling

locals {
  name_prefix = "ecs-cluster${var.cluster_name}-${var.name}"
  resource_id = "service/${var.cluster_name}/${var.name}"
}

data "aws_iam_role" "scaling_role" {
  name = "${var.scaling_role}"

  count = "${var.autoscale ? 1 : 0}"
}

resource "aws_appautoscaling_target" "default" {
  max_capacity       = "${var.max_capacity}"
  min_capacity       = "${var.min_capacity}"
  resource_id        = "${local.resource_id}"
  role_arn           = "${data.aws_iam_role.scaling_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  count = "${var.autoscale ? 1 : 0}"
}

resource "aws_appautoscaling_policy" "scale_out_policy" {
  name               = "${local.name_prefix}-scale-out-policy"
  service_namespace  = "ecs"
  resource_id        = "${local.resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_out_cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  count      = "${var.autoscale ? 1 : 0}"
  depends_on = ["aws_appautoscaling_target.default"]
}

module "scale_out_alarm" {
  source = "../alarm"

  enable             = "${var.autoscale}"
  metric_name        = "${var.scaling_metric}"
  cluster_name       = "${var.cluster_name}"
  service_name       = "${var.name}"
  period             = "${var.scale_out_period}"
  evaluation_periods = "${var.scale_out_evaluation_periods}"
  statistic          = "${var.scale_out_statistic}"
  threshold          = "${var.scale_out_threshold}"
  policy_arn         = "${join("", aws_appautoscaling_policy.scale_out_policy.*.arn)}"
}

resource "aws_appautoscaling_policy" "scale_in_policy" {
  name               = "${local.name_prefix}-scale-in-policy"
  service_namespace  = "ecs"
  resource_id        = "${local.resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.scale_in_cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  count      = "${var.autoscale ? 1 : 0}"
  depends_on = ["aws_appautoscaling_target.default"]
}

module "scale_in_alarm" {
  source = "../alarm"

  enable             = "${var.autoscale}"
  metric_name        = "${var.scaling_metric}"
  scale_type         = "in"
  cluster_name       = "${var.cluster_name}"
  service_name       = "${var.name}"
  period             = "${var.scale_in_period}"
  evaluation_periods = "${var.scale_in_evaluation_periods}"
  statistic          = "${var.scale_in_statistic}"
  threshold          = "${var.scale_in_threshold}"
  policy_arn         = "${join("", aws_appautoscaling_policy.scale_in_policy.*.arn)}"
}
