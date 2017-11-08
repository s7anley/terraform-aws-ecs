variable "instance_role_name" {
  description = "The name of the role used for instance profile."
}

variable "load_balancing_role_name" {
  description = "The name of the IAM role which allow ECS service to use ALB."
}

variable "skip_load_balancing_role" {
  description = "Skip creation of IAM role associated with load balanced service."
  default     = false
}

variable "autoscale_role_name" {
  description = "The name of the role for ECS service which could be autoscaled. Creation of new role is skipped, if you specify autoscale_role."
}

variable "skip_autoscale_role" {
  description = "Skip creation of IAM role associated with auto scaled service."
  default     = false
}
