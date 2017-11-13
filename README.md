# Amazon EC2 Container Service Module

This repo contains a modules to deploy a ECS Cluster, Tasks and Services on AWS using Terraform. Amazon EC2 Container Service is a highly scalable, fast, container management service that makes it easy to run, stop, and manage Docker containers on a cluster of EC2 instances.

## How to use this module

```hcl
module "ecs" {
  source = "github.com/s7anley/terraform-amazon-ecs"

  cluster_name = "demo-cluster"

  # ec2 instaces configuration
  key_name          = "existing-key"
  instance_type     = "m4.large"
  block_device_size = 50
  vpc_subnets       = ["${aws_subnet.private.*.id}"]
  security_groups   = ["${aws_vpc.default.default_security_group_id}"]

  # scaling configuration
  min_size = 2
  max_size = 4

  # It's recommended to define image_id, to avoid change of image once Amazon
  # releases the new version of the image.
  # image_id = "ami-20ff515a"
}

module "web" {
  source = "github.com/s7anley/terraform-amazon-ecs/modules/task"

  name          = "web"
  image         = "docker/example-voting-app-vote:latest"
  memory        = 256
  env_vars      = [
    {
       name  = "MY_ENV_VAR"
       value = "foobar"
    },
  ]

  port_mappings = [
    {
      hostPort      = 0
      containerPort = 80
      protocol      = "tcp"
    },
  ]
}

module "webservice" {
  source = "github.com/s7anley/terraform-amazon-ecs/modules/service"

  name            = "api"
  cluster_name    = "${module.ecs.cluster_name}"
  task_definition = "${module.web.task_family}:${module.web.task_revision}"

  # autoscale
  autoscale    = true
  scaling_role = "${module.ecs.autoscale_role_name}"

  # load balancing
  has_load_balancer   = true
  container_name      = "api"
  container_port      = 80
  vpc_id              = "${aws_vpc.default.id}"
  alb_subnets         = ["${aws_subnet.public.*.id}"]
  alb_security_groups = ["${aws_vpc.default.default_security_group_id}"]
  service_role        = "${module.ecs.load_balancing_role_name}"
}
```

## License

This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/s7anley/terraform-amazon-ecs/tree/master/LICENSE).
