variable "name" {
  description = "The name of a container."
}

variable "image" {
  default = "The image used to start a container."
}

variable "cpu" {
  description = "The number of cpu units to reserve for the container."
  default     = 0
}

variable "memory" {
  description = "The hard limit (in MiB) of memory to present to the container."
}

variable "env_vars" {
  type        = "list"
  description = "The environment variables to pass to a container."
  default     = []
}

variable "entry_point" {
  type        = "list"
  description = "The entry point that is passed to the container."
  default     = []
}

variable "command" {
  type        = "list"
  description = "The command that is passed to the container."
  default     = []
}

variable "port_mappings" {
  type        = "list"
  description = "Port mappings allow containers to access ports on the host container instance to send or receive traffic."
  default     = []
}

variable "links" {
  type        = "list"
  description = "The link parameter allows containers to communicate with each other without the need for port mappings."
  default     = []
}

variable "mount_points" {
  type        = "list"
  description = "The mount points for data volumes in your container. "
  default     = []
}

variable "volumes_from" {
  type        = "list"
  description = "Data volumes to mount from another container."
  default     = []
}

variable "task_role_arn" {
  description = "IAM role that allows the containers in the task permission to call the AWS API"
  default     = ""
}
