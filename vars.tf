
# AWS provider variable definition
variable "AWS_ACCESS_KEY" {} # See terraform.tfvars
variable "AWS_SECRET_KEY" {} # See terraform.tfvars
variable "AWS_REGION" {
  description = "The default AWS region"
  default = "ap-southeast-2" # Asia Pacific (Sydney)
}

# AWS global resource variable definition (prompted unless supplied at command line)
variable "ENV" {
  description = "Specify the environment: 'dev' or 'prod'"
  type = "string"
}

# AWS AMI ID variable definition (apply separate AMI IDs for each AWS region)
variable "AMI_ID" {
  description = "The AMI IDs to use per region"
  type = "map"
  default = {
    ap-southeast-2 = "ami-0fc740bda78beedac" # CentOS Linux 6 x86_64 HVM EBS ENA 1901_01
  }
}

# AWS EC2 instance type variable definition
variable "INSTANCE_TYPE" {
  description = "The instance type to use per environment"
  type = "map"
  default = {
    dev = "t2.micro"
    prod = "t2.medium"
  }
}

# Instance count variable definition
variable "INSTANCE_COUNT" {
  description = "The instance count to use per environment"
  type = "map"
  default = {
    dev = 1
    prod = 2 # Cross-AZ HA configuration
  }
}

# EC2 key-pair variable definition (see ec2.tf and keypair.tf)
variable "PATH_TO_PRIVATE_KEY" {
  description = "The name of the private key file in working directory"
  default = "wordpress_ec2"
}
variable "PATH_TO_PUBLIC_KEY" {
  description = "The name of the public key file in working directory"
  default = "wordpress_ec2.pub"
}

# AWS RDS instance type variable definition
variable "DB_INSTANCE_SIZE" {
  description = "The RDS instance type to use per environment"
  type = "map"
  default = {
    dev = "db.t2.micro"
    prod = "db.t2.medium"
  }
}

# AWS RDS volume size variable definition
variable "DB_VOL_SIZE" {
  description = "The RDS volume size to use per environment"
  type = "map"
  default = {
    dev = 25 # GiB
    prod = 100 # GiB (best IOPS balance)
  }
}

# AWS RDS multi-az variable definition
variable "DB_MULTI_AZ" {
  description = "The RDS multi-az attribute to use per environment"
  type = "map"
  default = {
    dev = "false"
    prod = "true" # Cross-AZ HA configuration
  }
}

# AWS RDS password variable definition (prompted unless supplied at command line)
variable "RDS_PASSWORD" {}
