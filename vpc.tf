resource "aws_subnet" "myapp-subnet" {
  count = "${length(var.subnet_cidrs_public)}"
  vpc_id = "${aws_vpc.myapp-vpc.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Micro-vpc"
  }
}

resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "Micro_gateway"
  }
}

resource "aws_route_table" "test_route" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "Micro-route"
  }
}

resource "aws_route_table_association" "associate" {
  count = "${length(var.subnet_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.myapp-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.test_route.id}"
}

