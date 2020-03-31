variable "region" {
  type = string
  description = "Service region"
  default = "ap-southeast-2"
}

variable "timeout" {
  type = number
  description = "Set timeout for lambda function"
  default = 300
}

variable "memory_size" {
  type = number
  description = "Set memory size for lambda invocation"
  default = 256
}
variable "environment_variables" {
  description = "Environment variables used by lambda function"
  type = "map"
}

variable "schedule_expression" {
  description = "Cloud watch event schedule expression"
  default = "rate(6 hours)"
  type = string
}
