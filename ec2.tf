
# EC2 resource configuration
resource "aws_instance" "wordpress_ec2" {
  ami = "${lookup(var.AMI_ID, var.AWS_REGION)}" # See vars.tf
  instance_type = "${var.ENV == "dev" ? "t2.micro" : "t3.small"}" # If DEV; use smaller instance
  key_name = "${aws_key_pair.wordpress_ec2_keypair.key_name}" # Specified for SSH access if required; will require Elastic IP and Security Group updates
#  associate_public_ip_address = "" # Required for SSH access
  subnet_id = "${aws_subnet.app-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.instance_secgroup.id}"]

  root_block_device {
    volume_type = "gp2" # General Purpose SSD
    volume_size = 20 # Size in gibibytes, upgraded from the default 8 GiB
    delete_on_termination = true # Volume will be destroyed on termination
  }

#  user_data = ""

  tags {
    Name = "wordpress-ec2-${var.ENV}-1"
    Environment = "${var.ENV}"
  }

  volume_tags {
    Name = "wordpress-ec2-${var.ENV}-1"
    Environment = "${var.ENV}"
  }
}
