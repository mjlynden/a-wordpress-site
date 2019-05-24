
# AWS provider variable definition
variable "AWS_ACCESS_KEY" {} # See terraform.tfvars
variable "AWS_SECRET_KEY" {} # See terraform.tfvars
variable "AWS_REGION" {
  description = "The default AWS region"
  default     = "ap-southeast-2" # Asia Pacific (Sydney)
}

# AWS global resource variable definition
variable "ENV" {
  description = "Specify the environment: 'dev' or 'prod'"
  type        = "string"
}
