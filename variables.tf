variable "instance_profile" {
  description = "Name of existing IAM role with  attached AmazonEC2ContainerServiceforEC2Role policy."
  default     = ""
}

variable "instance_role_name" {
  description = "The name of the role used for instance profile. Creation of new role and instance profile is skipped, if you specify instance_profile."
  default     = "ecs-instance-role"
}

variable "service_role" {
  description = "Name of existing of IAM role for ECS containers. If service has a load balancer, IAM role has to have AmazonEC2ContainerServiceRole policy attached."
  default     = ""
}

variable "service_role_name" {
  description = "The name of the default role for ECS service. Creation of new role is skipped, if you specify service_role."
  default     = "ecs-service-role"
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
}

variable "key_name" {
  description = "The name for the key pair."
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
  description = "The EC2 image ID to launch. If omited, latest amazon-ecs-optimized image is used"
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
  description = "The tenancy of the instance. Valid values are default or dedicated"
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

variable "default_vpc_azs" {
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
  description = "A list of metrics to collect."

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}
