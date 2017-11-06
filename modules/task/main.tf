locals {
  search  = "/\"(\\d+)\"/"
  replace = "$1"
}

data "template_file" "default" {
  template = "${file("${path.module}/task.json")}"

  vars {
    name          = "${var.name}"
    image         = "${var.image}"
    cpu           = "${var.cpu}"
    memory        = "${var.memory}"
    task_role_arn = "${var.task_role_arn}"

    environment_vars = "${jsonencode(var.env_vars)}"
    entry_point      = "${jsonencode(var.entry_point)}"
    command          = "${jsonencode(var.command)}"

    # the replace hack is required because types are not preserved when
    # encoding to JSON and mapped struct in terraform required ports to be int
    port_mappings = "${replace(jsonencode(var.port_mappings), local.search, local.replace)}"

    links        = "${jsonencode(var.links)}"
    mount_points = "${jsonencode(var.mount_points)}"
    volumes_from = "${jsonencode(var.volumes_from)}"
  }
}

resource "aws_ecs_task_definition" "default" {
  family                = "${var.name}"
  container_definitions = "${data.template_file.default.rendered}"
}
