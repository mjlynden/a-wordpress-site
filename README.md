# A Wordpress Site
### Based on Terraform

## Overview
This project will create a Wordpress site for development or production purposes within AWS.
**Note:** Production will utilise larger resources than development.

## Resources
The following resources will be created for either development (dev) or production (prod), depending on user selection. In the case of production, more than one resource of a particular type below will be created.
 * vpc
 * ec2
 * rds (mysql)
 * elb (load balancer)
 * efs (ec2 shared file system)

## Basic Usage

**Note:** The following should take place within the project's root directory.

1) Create yourself a ssh-keypair:
`ssh-keygen -f wordpress_ec2`

2) Supply your AWS credentials within a new file (as below): *__'terraform.tfvars'__*
>AWS_ACCESS_KEY = "AKIA..."  
>AWS_SECRET_KEY = "YvbB..."

3) Setup Terraform:  
`terraform init`

4) Apply Terraform (you will be prompted to supply a password for the RDS database):  
`terraform plan` followed by:  
`terraform apply -var ENV=dev` or `terraform apply -var ENV=prod`

5) The following outputs will be supplied on successful build:
 * ELB endpoint
 * EC2 IP(s)

 6) When complete:  
 `terraform destroy -var ENV=dev`
 
 ### Declaration
 All work is my own.
