variable "region" {
  type = string
  description = "Service region"
  default = "ap-southeast-2"
}

variable "timeout" {
  type = number
  default = 300
}

variable "memory_size" {
  type = number
  default = 256
}
variable "environment_variables" {
  type = "map"
}
