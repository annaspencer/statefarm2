

variable "function_name" {
  type        = string
  description = "Function name"
  default     = "hello-world"
}

variable "describe_function" {
  type        = string
  description = "A description of the function. Very inception."
  default     = "Describe me."
}

# This must be a unique name
# The AWS_DEFAULT_ROLE in the .gitlab-ci.yml must match the role here.
variable "role_name" {
  type        = string
  description = "IAM role for AWS"
  default     = "demo_terraform_2020"
}

# This must be a unique name
# The AWS_S3_ZIP_FILE in the .gitlab-ci.yml must match the role here.
variable "s3_key" {
  type        = string
  description = "The key location for the serverless package"
  default     = "v1.0.0/hello-world.zip"
}

################# DO NOT CHANGE ANY OF THE VARIABLES BELOW THIS LINE #################

variable "region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-west-2"
}

variable "handler" {
  type        = string
  description = "The handler for the serverless invocation"
  default     = "main.handler"
}

variable "runtime" {
  type        = string
  description = "The handler runtime for serverless invocation"
  default     = "nodejs10.x"
}

variable "s3_bucket" {
  type        = string
  description = "The S3 bucket that holds the packaged function"
  default     = "2020-terraform-demo"
}
