
# Subnet IDs data source configuration
data "aws_subnet_ids" "app_subnets" {
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = ["aws_subnet.app_subnet_1", "aws_subnet.app_subnet_2"] # The application subnet IDs cannot be retrieved until they are created

  tags = {
    Layer = "app"
  }
}

# EC2 resource configuration
resource "aws_instance" "wordpress_ec2" {
  ami = "${lookup(var.AMI_ID, var.AWS_REGION)}" # See vars.tf
  instance_type = "${lookup(var.INSTANCE_TYPE, var.ENV)}" # See vars.tf
  count = "${lookup(var.INSTANCE_COUNT, var.ENV)}" # See vars.tf
  key_name = "${aws_key_pair.wordpress_ec2_keypair.key_name}" # Specified for SSH access if required; will require Elastic IP and Security Group updates
#  associate_public_ip_address = "" # Required for SSH access
  subnet_id = "${element(data.aws_subnet_ids.app_subnets.ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.instance_secgroup.id}"]
  root_block_device {
    volume_type = "gp2" # General Purpose SSD
    volume_size = 20 # Size in gibibytes, upgraded from the default 8 GiB
    delete_on_termination = true # Volume will be destroyed on termination
  }

  tags {
    Name = "wordpress-ec2-${var.ENV}"
    Environment = "${var.ENV}"
  }

  volume_tags {
    Name = "wordpress-ec2-${var.ENV}"
    Environment = "${var.ENV}"
  }
}
