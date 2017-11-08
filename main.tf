module "iam" {
  source = "./modules/iam"

  instance_role_name       = "${var.instance_role_name}"
  load_balancing_role_name = "${var.load_balancing_role_name}"
  skip_load_balancing_role = "${var.skip_load_balancing_role}"
  autoscale_role_name      = "${var.autoscale_role_name}"
  skip_autoscale_role      = "${var.skip_autoscale_role}"
}

resource "aws_ecs_cluster" "default" {
  name = "${var.cluster_name}"
}

data "aws_ami" "default" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*.a-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_key_pair" "default" {
  count = "${var.key_file != "" ? 1 : 0}"

  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

resource "aws_launch_configuration" "default" {
  # only create new launch configuration if a name is not configured
  count = "${var.launch_configuration == "" ? 1 : 0}"

  name                 = "${var.cluster_name}-lc"
  image_id             = "${var.image_id != "" ? var.image_id : data.aws_ami.default.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${module.iam.instance_profile_name}"
  key_name             = "${var.key_name}"
  security_groups      = ["${var.security_groups}"]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"
  enable_monitoring    = "${var.enable_monitoring}"
  spot_price           = "${var.spot_price}"
  placement_tenancy    = "${var.placement_tenancy}"

  # used for docker images, container volumes etc.
  ebs_block_device = {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = "${var.block_device_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  name                 = "${var.cluster_name}-asg"
  launch_configuration = "${coalesce(var.launch_configuration, join("", aws_launch_configuration.default.*.name))}"
  enabled_metrics      = ["${var.metrics}"]

  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  desired_capacity          = "${var.desired_capacity}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  availability_zones  = ["${var.vpc_azs}"]
  vpc_zone_identifier = ["${var.vpc_subnets}"]

  tags = [
    {
      key                 = "Name"
      value               = "ecs-${var.cluster_name}"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = "${var.cluster_name}"
      propagate_at_launch = "true"
    },
  ]

  lifecycle {
    create_before_destroy = true
  }

  count = "${var.autoscaling_group == "" ? 1 : 0}"
}

module "scaling" {
  enable                 = "${var.autoscale}"
  source                 = "./modules/scaling"
  cluster_name           = "${aws_ecs_cluster.default.name}"
  autoscaling_group_name = "${coalesce(var.autoscaling_group, join("", aws_autoscaling_group.default.*.name))}"
}
