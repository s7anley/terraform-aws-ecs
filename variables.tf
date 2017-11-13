variable "instance_role_name" {
  description = "The name of the role used for instance profile."
  default     = "ecs-instance-role"
}

variable "load_balancing_role_name" {
  description = "The name of the IAM role which allow ECS service to use ALB."
  default     = "ecs-service-role"
}

variable "skip_load_balancing_role" {
  description = "Skip creation of IAM role associated with load balanced service."
  default     = false
}

variable "autoscale_role_name" {
  description = "The name of the role for ECS service which could be autoscaled. Creation of new role is skipped, if you specify autoscale_role."
  default     = "ecs-autoscale-role"
}

variable "skip_autoscale_role" {
  description = "Skip creation of IAM role associated with auto scaled service."
  default     = false
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
}

variable "key_name" {
  description = "The name for the key pair."
  default     = ""
}

variable "key_file" {
  description = "The path to the file with the public key. If provided, a key pair is created otherwise pair with `key_name` is used."
  default     = ""
}

variable "launch_configuration" {
  description = "Name of the already existing launch configuration. Creation of new launch configuration will be skipped."
  default     = ""
}

variable "image_id" {
  description = "The EC2 image ID to launch. If omitted, the latest amazon-ecs-optimized image is used. It's recommended to define image_id, to avoid change of image once Amazon releases the new version of the image."
  default     = ""
}

variable "instance_type" {
  description = "The size of instance to launch."
  default     = "m4.large"
}

variable "security_groups" {
  type        = "list"
  description = "A list of associated security group IDS."
  default     = []
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  default     = true
}

variable "spot_price" {
  description = "The price to use for reserving spot instances."
  default     = ""
}

variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are default or dedicated."
  default     = "default"
}

variable "block_device_size" {
  description = "The size of the volume in gigabytes."
  default     = 50
}

variable "autoscale" {
  description = "Configure alarms and auto scale ecs cluster."
  default     = true
}

variable "autoscaling_group" {
  description = "Name of the already existing autoscaling group. Creation of new group will be skipped."
  default     = ""
}

variable "max_size" {
  description = "The maximum size of the auto scale group."
  default     = 4
}

variable "min_size" {
  description = "The minimum size of the auto scale group."
  default     = 1
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = 1
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out."
  default     = 0
}

variable "vpc_azs" {
  type        = "list"
  description = "A list of AZs to launch resources in default VPC. Required only if you do not specify any vpc_subnets."
  default     = []
}

variable "vpc_subnets" {
  type        = "list"
  description = "A list of subnet IDs to launch resources in."
  default     = []
}

variable "metrics" {
  type        = "list"
  description = "A list of metrics to collect. Supported metrics: GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances."

  default = []
}
