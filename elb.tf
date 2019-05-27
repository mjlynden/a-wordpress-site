
# Classic ELB resource configuration
resource "aws_elb" "elb" {
  name = "elb-${var.ENV}"
  subnets = ["${aws_subnet.dmz-subnet-1.id}", "${aws_subnet.dmz-subnet-2.id}"]
  security_groups = ["${aws_security_group.elb_secgroup.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = "10"
    unhealthy_threshold = "2"
    timeout = "5"
    target = "TCP:80"
    interval = "30"
  }

  cross_zone_load_balancing = true # Default is 'true'; defining it explicitly
  connection_draining = true
  connection_draining_timeout = 300

  tags = {
    Name = "elb-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

# Attach Wordpress EC2 instance(s) to ELB
resource "aws_elb_attachment" "elb_wordpress_ec2" {
  depends_on = ["aws_instance.wordpress_ec2"] # Create EC2 instance before attempting to attach to ELB
  count = "${lookup(var.INSTANCE_COUNT, var.ENV)}" # See vars.tf
  elb = "${aws_elb.elb.id}"
  instance = "${element(aws_instance.wordpress_ec2.*.id, count.index)}"
}
