
# RDS resource configuration
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnet-group-${var.ENV}"
  description = "Subnet group for database"
  subnet_ids = ["${aws_subnet.db_subnet_1.id}", "${aws_subnet.db_subnet_2.id}"]

  tags = {
    Name = "db-subnet-group-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name = "db-parameter-group-${var.ENV}"
  family = "mysql5.6"
  description = "Parameter group for database"

  tags = {
    Name = "db-parameter-group-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_db_instance" "db" {
  identifier = "wordpress-rds-${var.ENV}"
  instance_class = "${lookup(var.DB_INSTANCE_SIZE, var.ENV)}" # See vars.tf
  multi_az = "${lookup(var.DB_MULTI_AZ, var.ENV)}" # See vars.tf
  allocated_storage = "${lookup(var.DB_VOL_SIZE, var.ENV)}" # See vars.tf
  storage_type = "gp2" # General Purpose SSD
  engine = "mysql"
  engine_version = "5.6"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.name}"
  parameter_group_name = "${aws_db_parameter_group.db_parameter_group.name}"
  vpc_security_group_ids = ["${aws_security_group.db_secgroup.id}"]
  username = "root"
  password = "${var.RDS_PASSWORD}" # See vars.tf
  name = "wordpress" # Wordpress database name
  backup_retention_period = 30 # days
  skip_final_snapshot = true # Skip snapshot creation on terraform destroy

  tags {
    Name = "wordpress-rds-${var.ENV}"
    Environment = "${var.ENV}"
  }
}
