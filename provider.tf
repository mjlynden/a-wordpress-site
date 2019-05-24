
# AWS provider configuration
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}" # See terraform.tfvars
  secret_key = "${var.AWS_SECRET_KEY}" # See terraform.tfvars
  region     = "${var.AWS_REGION}" # See vars.tf
}
