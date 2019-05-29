
# Security groups resource configuration
resource "aws_security_group" "elb_secgroup" {
  name = "elb-secgroup-${var.ENV}"
  description = "Security group for ELB"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open HTTP inbound access to world"
  }

  # This rule needs to be explicitly defined as Terraform removes the AWS default egress rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic outbound"
  }

  tags {
    Name = "elb-secgroup-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_security_group" "instance_secgroup" {
  name = "instance-secgroup-${var.ENV}"
  description = "Security group for instance"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb_secgroup.id}"]
    description = "Open HTTP inbound access from ELB"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Should be locked down to an administrator(s) IP
    description = "Open SSH inbound access"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = "true"
    description = "Open ALL inbound access from this security group"
  }

  # This rule needs to be explicitly defined as Terraform removes the AWS default egress rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic outbound"
  }

  tags {
    Name = "instance-secgroup-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

  resource "aws_security_group" "db_secgroup" {
    name = "db-secgroup-${var.ENV}"
    description = "Security group for database"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = ["${aws_security_group.instance_secgroup.id}"]
      description = "Open database connectivity inbound from instance"
    }

    # This rule needs to be explicitly defined as Terraform removes the AWS default egress rule
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all traffic outbound"
    }

    tags {
      Name = "db-secgroup-${var.ENV}"
      Environment = "${var.ENV}"
    }
}
