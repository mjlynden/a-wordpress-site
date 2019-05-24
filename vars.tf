
# AWS provider variable definition
variable "AWS_ACCESS_KEY" {} # See terraform.tfvars
variable "AWS_SECRET_KEY" {} # See terraform.tfvars
variable "AWS_REGION" {
  description = "The default AWS region"
  default     = "ap-southeast-2" # Asia Pacific (Sydney)
}
