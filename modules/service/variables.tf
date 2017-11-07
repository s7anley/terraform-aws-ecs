variable "name" {
  description = "The name of the service."
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
}

variable "task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition that you want to run in your service."
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running."
  default     = 1
}

variable "min_healthy_percent" {
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 50
}

variable "max_healthy_percent" {
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment."
  default     = 200
}

# Load balancing

variable "has_load_balancer" {
  description = "Create and associate application load balancer with service."
  default     = false
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to service. Only used when creating load balancer."
  default     = ""
}

variable "service_role_id" {
  description = "The ARN of IAM role to attach with container. If service has load balancer, IAM role has to have AmazonEC2ContainerServiceRole policy attached."
  default     = ""
}

variable "alb_port" {
  description = "The port on which the load balancer is listening."
  default     = 80
}

variable "alb_protocol" {
  description = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS."
  default     = "HTTP"
}

variable "alb_subnets" {
  type        = "list"
  description = "A list of subnet IDs to attach to the LB."
  default     = []
}

variable "alb_security_groups" {
  type        = "list"
  description = "A list of security group IDs to assign to the LB."
  default     = []
}

variable "container_name" {
  description = "The name of the container to associate with the load balancer."
  default     = ""
}

variable "container_port" {
  description = "The port on the container to associate with the load balancer."
  default     = 80
}

# Autoscale

variable "autoscale" {
  description = "Enable autoscaling for service."
  default     = false
}

variable "max_capacity" {
  description = "The maximum number of running service containers."
  default     = 4
}

variable "min_capacity" {
  description = "The minimum number of running service containers."
  default     = 1
}

variable "scaling_role" {
  description = "The ARN of IAM role with associated policy AmazonEC2ContainerServiceAutoscaleRole."
  default     = ""
}

variable "scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling out activity can start."
  default     = 120
}

variable "scale_out_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for scaling out alarm."
  default     = 3
}

variable "scale_out_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum."
  default     = "Average"
}

variable "scale_out_period" {
  description = "The period in seconds over which the specified statistic is applied for scaling out alarm."
  default     = 60
}

variable "scale_out_threshold" {
  description = "The value against which the specified statistic is compared for scaling out alarm."
  default     = 80
}

variable "scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling in activity can start."
  default     = 300
}

variable "scale_in_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for scaling in alarm."
  default     = 1
}

variable "scale_in_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum."
  default     = "Average"
}

variable "scale_in_period" {
  description = "The period in seconds over which the specified statistic is applied for scaling in alarm."
  default     = 300
}

variable "scale_in_threshold" {
  description = "The value against which the specified statistic is compared for scaling in alarm."
  default     = 15
}
