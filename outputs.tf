
# Outputs configuration to be displayed within the terminal
output "ELB Endpoint Address:" {
  description = "The ELB endpoint address"
  value = "${aws_elb.elb.dns_name}"
}

output "RDS Endpoint Address:" {
  description = "The RDS endpoint address"
  value = "${aws_db_instance.db.endpoint}"
}
