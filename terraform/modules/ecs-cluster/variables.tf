variable "name" {
  description = "name for the cluster"
}

variable "use_spot" {
  default = false
}

variable "spot_target_capacity" {
  default = 1
}

variable "spot_price" {
  description = "Max price for each instance (in USD)"
  default     = 0
}

variable "spot_valid_until" {
  default = "2020-11-13T00:00:00Z"
}

variable "spot_allocation_strategy" {
  default = "diversified"
}

variable "auto_scaling_desired_capacity" {
  description = "Desired instance count"
  default     = 1
}

variable "auto_scaling_min_size" {
  description = "Min instance count"
  default     = 1
}

variable "auto_scaling_max_size" {
  description = "Max instance count"
  default     = 1
}


variable "instance_type" {
  description = "The instance type to use, e.g t2.small"
}

variable "instance_ami" {
  description = "The AMI to each instance"
}

variable "custom_cloudinit_config" {
  description = "Custom cloudinit config for the container instances"
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = "list"
}

variable "availability_zones" {
  description = "List of AZs"
  type        = "list"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = "list"
}

variable "key_name" {
  description = "SSH key name to use"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 20
}

variable "docker_volume_size" {
  description = "Attached EBS volume size in GB"
  default     = 40
}
