# Workaround, because lack of support for count parameter when using modules
variable "enable" {
  description = "Enable autoscaling for ECS cluster"
  default     = true
}

variable "cluster_name" {
  description = "The name of the ECS Cluster."
}

variable "autoscaling_group_name" {
  default = "The name of autoscaling group associated with ECS cluster."
}

variable "scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling out activity can start."
  default     = "300"
}

variable "scale_out_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for scaling out alarm."
  default     = "3"
}

variable "scale_out_period" {
  description = "The period in seconds over which the specified statistic is applied for scaling out alarm."
  default     = "60"
}

variable "scale_out_threshold" {
  description = "The value against which the specified statistic is compared for scaling out alarm."
  default     = "80"
}

variable "scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling in activity can start."
  default     = "300"
}

variable "scale_in_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for scaling in alarm."
  default     = "1"
}

variable "scale_in_period" {
  description = "The period in seconds over which the specified statistic is applied for scaling in alarm."
  default     = "300"
}

variable "scale_in_threshold" {
  description = "The value against which the specified statistic is compared for scaling in alarm."
  default     = "15"
}
