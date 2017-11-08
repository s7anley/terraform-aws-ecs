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

module "ecs" {
  source = "../../"

  cluster_name = "demo-cluster"

  instance_role_name = "ecsInstanceRole"

  # ec2 instaces configuration
  instance_type     = "t2.small"
  block_device_size = 22
  vpc_azs           = ["${local.az}"]
  security_groups   = ["${data.aws_security_group.default.id}"]

  # scaling configuration
  autoscale        = false
  desired_capacity = 1

  # disable auto creation of roles, since we don't need them
  skip_load_balancing_role = true
  skip_autoscale_role      = true
}

module "web" {
  source = "../../modules/task"

  name   = "web"
  image  = "docker/example-voting-app-vote:latest"
  memory = 256
}

module "webservice" {
  source = "../../modules/service"

  name            = "web"
  cluster_name    = "${module.ecs.cluster_name}"
  task_definition = "${module.web.task_family}:${module.web.task_revision}"

  # autoscale
  autoscale         = false
  has_load_balancer = false
}
