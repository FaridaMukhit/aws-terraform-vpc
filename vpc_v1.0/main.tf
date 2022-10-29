######### VPC #########
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy
  tags = {
    Name = "${var.env}-vpc"
  }
}

########### Public Subnets ##########
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_subnet_cidrA
  availability_zone = var.az_1a
  tags = {
    Name = "${var.env}-public-subnet-A"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_subnet_cidrB
  availability_zone = var.az_1b
  tags = {
    Name = "${var.env}-public-subnet-B"
  }
}

resource "aws_subnet" "public_subnet3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_subnet_cidrC
  availability_zone = var.az_1c
  tags = {
    Name = "${var.env}-public-subnet-C"
  }
}

########### Public Route Table ###########
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public-route-table"
  }
}

########## Public Route Table Association #########
resource "aws_route_table_association" "public_route_table1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table4" {
  gateway_id     = aws_internet_gateway.internet_gateway.id
  route_table_id = aws_route_table.public_route_table.id
}

######### Internet Gateway ##########
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-internet-gateway"
  }
}

######## Private Subnets ##########
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrA
  availability_zone = var.az_1a
  tags = {
    Name = "${var.env}-private-subnet-A"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrB
  availability_zone = var.az_1b
  tags = {
    Name = "${var.env}-private-subnet-B"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrC
  availability_zone = var.az_1c
  tags = {
    Name = "${var.env}-private-subnet-C"
  }
}

########### Private Route Table ###########
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.env}-private-route-table"
  }
}

########## Private Route Table Association #########
resource "aws_route_table_association" "private_route_table1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_route_table.id
}

############ NAT Gateaway ##############
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.env}-nat-gateway"
  }
}

######### Elastic IP ############
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "${var.env}-elastic-ip"
  }
}
