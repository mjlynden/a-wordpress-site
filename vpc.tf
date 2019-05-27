
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
resource "aws_subnet" "dmz-subnet-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags {
    Name = "${var.ENV}-dmz-subnet-1"
    Environment = "${var.ENV}"
    Layer = "dmz"
  }
}

resource "aws_subnet" "dmz-subnet-2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.2.0/24"
  availability_zone = "${var.AWS_REGION}b"
  tags {
    Name = "${var.ENV}-dmz-subnet-2"
    Environment = "${var.ENV}"
    Layer = "dmz"
  }
}

resource "aws_subnet" "app-subnet-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.3.0/24"
  availability_zone = "${var.AWS_REGION}a"
  tags {
    Name = "${var.ENV}-app-subnet-1"
    Environment = "${var.ENV}"
    Layer = "app"
  }
}

resource "aws_subnet" "app-subnet-2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.4.0/24"
  availability_zone = "${var.AWS_REGION}b"
  tags {
    Name = "${var.ENV}-app-subnet-2"
    Environment = "${var.ENV}"
    Layer = "app"
  }
}

# VPC route table configuration
resource "aws_route_table" "dmz-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "dmz-route-table"
    Environment = "${var.ENV}"
  }
}

resource "aws_route_table" "app-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "app-route-table"
    Environment = "${var.ENV}"
  }
}

# VPC route table association configuration
resource "aws_route_table_association" "dmz-1" {
  subnet_id = "${aws_subnet.dmz-subnet-1.id}"
  route_table_id = "${aws_route_table.dmz-route-table.id}"
}

resource "aws_route_table_association" "dmz-2" {
  subnet_id = "${aws_subnet.dmz-subnet-2.id}"
  route_table_id = "${aws_route_table.dmz-route-table.id}"
}

resource "aws_route_table_association" "app-1" {
  subnet_id = "${aws_subnet.app-subnet-1.id}"
  route_table_id = "${aws_route_table.app-route-table.id}"
}

resource "aws_route_table_association" "app-2" {
  subnet_id = "${aws_subnet.app-subnet-2.id}"
  route_table_id = "${aws_route_table.app-route-table.id}"
}
