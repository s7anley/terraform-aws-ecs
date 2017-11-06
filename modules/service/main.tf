data "aws_ecs_cluster" "default" {
  cluster_name = "${var.cluster_name}"
}

resource "aws_ecs_service" "default" {
  count = "${var.has_load_balancer ? 0 : 1}"

  name            = "${var.name}"
  cluster         = "${data.aws_ecs_cluster.default.id}"
  task_definition = "${var.task_definition}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${var.service_role_id}"

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

  name     = "${var.name}-${data.aws_ecs_cluster.default.cluster_name}-tg"
  port     = "${var.alb_port}"
  protocol = "${var.alb_protocol}"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_security_group" "default" {
  count = "${var.has_load_balancer ? 1 : 0}"

  name        = "${var.name}-${data.aws_ecs_cluster.default.cluster_name}-alb-sc"
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

  name            = "${var.name}-${data.aws_ecs_cluster.default.cluster_name}-alb"
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
  iam_role        = "${var.service_role_id}"

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
