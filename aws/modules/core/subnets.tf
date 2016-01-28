resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.registers.id}"

  cidr_block = "${var.public_cidr_block}"

  tags = {
    Name = "${var.vpc_name}-public"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.registers.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "${var.vpc_name}-public-gateway"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

// Create default route with NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.registers.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.natgw.id}"
  }
  tags = {
    Name = "${var.vpc_name}-private-gateway"
    Environment = "${var.vpc_name}"
  }
}

// Endpoint to access S3

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id = "${aws_vpc.registers.id}"
  service_name = "com.amazonaws.eu-west-1.s3"
  route_table_ids = ["${aws_route_table.private.id}"]
  # do we want to add a policy restricting access to particular buckets?
}

// Set as default route
resource "aws_main_route_table_association" "private" {
  vpc_id = "${aws_vpc.registers.id}"
  route_table_id = "${aws_route_table.private.id}"
}
