variable "instance_profile" {
  description = "Name of existing IAM role with  attached AmazonEC2ContainerServiceforEC2Role policy."
  default     = ""
}

variable "instance_role_name" {
  description = "The name of the role used for instance profile. Creation of new role and instance profile is skipped, if you specify instance_profile."
  default     = "ecs-instance-role"
}

variable "service_role" {
  description = "Name of existing IAM role with  attached AmazonEC2ContainerServiceRole policy."
  default     = ""
}

variable "service_role_name" {
  description = "The name of the role for ECS service which uses ELB. Creation of new role is skipped, if you specify service_role."
  default     = "ecs-service-role"
}
