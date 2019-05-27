
# EC2 key-pair resource configuration
resource "aws_key_pair" "wordpress_ec2_keypair" {
  key_name = "wordpress_ec2"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
