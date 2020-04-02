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
  type = "map"
  description = "Environment variables used by lambda function"
  default = {}
}

variable "schedule_expression" {
  type = string
  description = "Cloud watch event schedule expression"
  default = "rate(6 hours)"
}

variable "lambda_function_s3_bucket" {
  type = string
  description = "The S3 bucket location containing the function's deployment package"
}

variable "lambda_function_s3_key" {
  type = string
  description = "The S3 key of an object containing the function's deployment package."
}
