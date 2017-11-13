provider "aws" {
  region = "us-east-1"
}

# Reuse existing default VPC and already created subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

data "aws_availability_zones" "available" {}

resource "aws_default_subnet" "primary" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_default_subnet" "secondary" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

locals {
  az = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
  ]

  subnets = [
    "${aws_default_subnet.primary.id}",
    "${aws_default_subnet.secondary.id}",
  ]
}

module "iam" {
  source = "../../modules/iam"

  instance_role_name       = "myInstanceRole"
  skip_load_balancing_role = true
  skip_autoscale_role      = true
}

resource "aws_launch_configuration" "custom" {
  # For now, it's not possible to let terraform generate new name, since this
  # will cause a problem with count and computed values inside of the module.
  # After each change of configuration,  you have to manually change
  # the name in order to update also autoscaling group.
  # See https://github.com/hashicorp/terraform/issues/10857
  name = "test"

  image_id             = "ami-20ff515a"
  iam_instance_profile = "${module.iam.instance_profile_name}"
  instance_type        = "c3.xlarge"
  security_groups      = ["${data.aws_security_group.default.id}"]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=demo-cluster > /etc/ecs/ecs.config"

  ephemeral_block_device = {
    device_name  = "/dev/xvdb"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device = {
    device_name  = "/dev/xvdc"
    virtual_name = "ephemeral1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "ecs" {
  source = "../../"

  cluster_name = "demo-cluster"

  # ec2 instaces configuration
  launch_configuration = "${aws_launch_configuration.custom.name}"
  vpc_azs              = ["${local.az}"]

  # scaling configuration
  autoscale        = false
  desired_capacity = 1

  # disable auto creation of roles, since we have manually called the module
  skip_instance_role       = true
  skip_load_balancing_role = true
  skip_autoscale_role      = true
}
