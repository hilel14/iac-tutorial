variable "instance_type" {
  description = "Value of the instace type for all the EC2 workers instances"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "The number of workers instances to launch"
  type        = number
  default     = 2
}

variable "spot_price" {
  description = "The spot price of each worker instance"
  type        = string
  default     = "0.03"
}

variable "instance_name_prefix" {
  description = "Worker instance name prefix. Actual name will include unique index number."
  type        = string
  default     = "worker"
}
