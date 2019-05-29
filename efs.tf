
# EFS resource configuration
resource "aws_efs_file_system" "efs" {
  creation_token = "wordpress-efs-${var.ENV}"

  tags = {
    Name = "wordpress-efs-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_efs_mount_target" "efs_mount_aza" {
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id = "${aws_subnet.app_subnet_1.id}"
  security_groups = ["${aws_security_group.instance_secgroup.id}"]
}

resource "aws_efs_mount_target" "efs_mount_azb" {
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id = "${aws_subnet.app_subnet_2.id}"
  security_groups = ["${aws_security_group.instance_secgroup.id}"]
}
