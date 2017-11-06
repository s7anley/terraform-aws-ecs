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
