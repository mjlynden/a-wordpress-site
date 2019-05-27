
# AWS provider variable definition
variable "AWS_ACCESS_KEY" {} # See terraform.tfvars
variable "AWS_SECRET_KEY" {} # See terraform.tfvars
variable "AWS_REGION" {
  description = "The default AWS region"
  default     = "ap-southeast-2" # Asia Pacific (Sydney)
}

# AWS global resource variable definition (prompt)
variable "ENV" {
  description = "Specify the environment: 'dev' or 'prod'"
  type        = "string"
}

# AWS AMI IDs for launching EC2 instances (apply separate IDs for each region)
variable "AMI_ID" {
  type = "map"
  default = {
    ap-southeast-2 = "ami-0fc740bda78beedac" # CentOS Linux 6 x86_64 HVM EBS ENA 1901_01
  }
}

# EC2 key-pair variable definition (see ec2.tf and keypair.tf)
variable "PATH_TO_PRIVATE_KEY" {
  default = "wordpress_ec2"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "wordpress_ec2.pub"
}
