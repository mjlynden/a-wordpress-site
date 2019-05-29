
# Subnet IDs data source configuration
data "aws_subnet_ids" "app_subnets" {
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = ["aws_subnet.app_subnet_1", "aws_subnet.app_subnet_2"] # The application subnet IDs cannot be retrieved until they are created

  tags = {
    Layer = "app"
  }
}

data "template_file" "bootstrap_script" {
  template = "${file("scripts/bootstrap.sh")}"

  vars = { # Render RDS attributes within bootstrap script
    ROOT_PWD = "${var.RDS_PASSWORD}"
    DB_HOST = "${aws_db_instance.db.address}"
    WP_DB_HOST = "${aws_db_instance.db.endpoint}" # Includes port number
  }
}

resource "aws_instance" "wordpress_ec2" {
  depends_on = ["aws_db_instance.db"] # The database should be available before the application can connect to it
  ami = "${lookup(var.AMI_ID, var.AWS_REGION)}" # See vars.tf
  instance_type = "${lookup(var.INSTANCE_TYPE, var.ENV)}" # See vars.tf
  count = "${lookup(var.INSTANCE_COUNT, var.ENV)}" # See vars.tf
  key_name = "${aws_key_pair.wordpress_ec2_keypair.key_name}" # Required for SSH access
  associate_public_ip_address = "true" # Required for SSH access (including access for file provisioner)
  subnet_id = "${element(data.aws_subnet_ids.app_subnets.ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.instance_secgroup.id}"]
  user_data = "${data.template_file.bootstrap_script.rendered}"

  root_block_device {
    volume_type = "gp2" # General Purpose SSD
    volume_size = 8 # Size in GiB
    delete_on_termination = true # Volume will be destroyed on instance termination
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
