
# Outputs configuration to be displayed within the terminal
output "ELB Endpoint Address:" { # See elb.tf
  description = "The ELB endpoint address"
  value = "${aws_elb.elb.dns_name}"
}

output "EC2 Public IP Address:" { # See ec2.tf
  description = "The EC2 instance public IP address"
  value = "${aws_instance.wordpress_ec2.*.public_ip}"
}
