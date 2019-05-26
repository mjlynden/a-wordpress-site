
# Outputs configuration to be displayed within the terminal
output "endpoint address" {
  description = "The ELB endpoint address"
  value = "${aws_elb.elb.dns_name}"
}
