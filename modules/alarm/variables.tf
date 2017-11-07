# Workaround, because lack of support for count parameter when using modules
variable "enable" {
  description = "Create alarm for ECS cluster or service."
  default     = true
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
}

variable "service_name" {
  description = "The name of the service."
  default     = ""
}

variable "scale_type" {
  description = "Type of scaling. Either of the following is supported in or out."
  default     = "out"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 1
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. Either of the following is supported MemoryUtilization or CPUUtilization."
  default     = "CPUUtilization"
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  default     = 300
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum."
  default     = "Average"
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
}

variable "policy_arn" {
  description = "The ARM of policy to execute when this alarm transitions into an ALARM state from any other state."
  default     = ""
}
