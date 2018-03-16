variable "aws_region" {
  type = "string"
  description = "AWS:region"
}

variable "aws_account_id" {
  type = "string"
  description = "AWS:account_id"
}

variable "namespace" {
  type = "string"
  description = "The namespace for the Lambda function"
}

variable "environment" {
  type = "string"
  description = "The environment (stage) for the Lambda function"
}

variable "name" {
  type = "string"
  description = "The name for the Lambda function"
}

variable "tags" {
  type = "map"
  description = "describe your variable"
  default = {}
}

variable "api_id" {
  type = "string"
  description = "The ID of the associated REST API"
}

variable "api_key_required" {
  description = "describe your variable"
  default = false
}

variable "dead_letter_config" {
  type = "map"
  description = "Nested block to configure the function's dead letter queue."
  default = {}
}

variable "filename" {
  type = "string"
  description = "The path to the function's deployment package within the local filesystem."
}

variable "handler" {
  type = "string"
  description = "The function entrypoint in your code."
}

variable "environment_variables" {
  type = "map"
  description = "A map that defines environment variables for the Lambda function."
  default = {}
}

variable "memory_size" {
  type = "string"
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default = "128"
}

variable "runtime" {
  type = "string"
  description = "The runtime environment for the Lambda function you are uploading. (nodejs, nodejs4.3, nodejs6.10, java8, python2.7, python3.6, dotnetcore1.0, nodejs4.3-edge)"
}

variable "timeout" {
  type = "string"
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default = "3"
}

variable "execution_policies" {
  type = "list"
  description = "List of Lambda Execution Policy ARNs"
  default = []
}

variable "vpc_subnet_ids" {
  type = "list"
  description = "A list of subnet IDs associated with the Lambda function."
  default = []
}

variable "vpc_security_group_ids" {
  type = "list"
  description = "A list of security group IDs associated with the Lambda function."
  default = []
}

variable "logs_policy" {
  description = "Create a policy for the logs. If true, then the logs policy will be create"
  default = true
}
