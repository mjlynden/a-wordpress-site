
# VPC resource configuration
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
  tags {
    Name = "vpc-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

# VPC internet gateway configuration
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "igw-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

# VPC subnet configuration
resource "aws_subnet" "dmz_subnet_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags {
    Name = "dmz-subnet-1-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "dmz"
  }
}

resource "aws_subnet" "dmz_subnet_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.2.0/24"
  availability_zone = "${var.AWS_REGION}b"
  tags {
    Name = "dmz-subnet-2-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "dmz"
  }
}

resource "aws_subnet" "app_subnet_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.3.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags {
    Name = "app-subnet-1-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "app"
  }
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.4.0/24"
  availability_zone = "${var.AWS_REGION}b"
  tags {
    Name = "app-subnet-2-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "app"
  }
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.5.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags {
    Name = "db-subnet-1-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "db"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.6.0/24"
  availability_zone = "${var.AWS_REGION}b"
  tags {
    Name = "db-subnet-2-${var.ENV}"
    Environment = "${var.ENV}"
    Layer = "db"
  }
}

# VPC route table configuration
resource "aws_route_table" "dmz_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "dmz-route-table-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_route_table" "app_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "app-route-table-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "db-route-table-${var.ENV}"
    Environment = "${var.ENV}"
  }
}

# VPC route table association configuration
resource "aws_route_table_association" "dmz_1" {
  subnet_id = "${aws_subnet.dmz_subnet_1.id}"
  route_table_id = "${aws_route_table.dmz_route_table.id}"
}

resource "aws_route_table_association" "dmz_2" {
  subnet_id = "${aws_subnet.dmz_subnet_2.id}"
  route_table_id = "${aws_route_table.dmz_route_table.id}"
}

resource "aws_route_table_association" "app_1" {
  subnet_id = "${aws_subnet.app_subnet_1.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}

resource "aws_route_table_association" "app_2" {
  subnet_id = "${aws_subnet.app_subnet_2.id}"
  route_table_id = "${aws_route_table.app_route_table.id}"
}

resource "aws_route_table_association" "db_1" {
  subnet_id = "${aws_subnet.db_subnet_1.id}"
  route_table_id = "${aws_route_table.db_route_table.id}"
}

resource "aws_route_table_association" "db_2" {
  subnet_id = "${aws_subnet.db_subnet_2.id}"
  route_table_id = "${aws_route_table.db_route_table.id}"
}
