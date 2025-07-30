# --- VPC ---
resource "aws_vpc" "student_app_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "StudentAppVPC"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "student_app_igw" {
  vpc_id = aws_vpc.student_app_vpc.id

  tags = {
    Name = "StudentAppIGW"
  }
}

# --- Public Subnets ---
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.student_app_vpc.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "StudentAppPublicSubnet-AZ1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.student_app_vpc.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "StudentAppPublicSubnet-AZ2"
  }
}

# --- Private Subnets ---
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.student_app_vpc.id
  cidr_block              = var.private_subnet_cidr[0]
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "StudentAppPrivateSubnet-AZ1"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.student_app_vpc.id
  cidr_block              = var.private_subnet_cidr[1]
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "StudentAppPrivateSubnet-AZ2"
  }
}

# --- NAT Gateway ---
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "StudentAppNatGW-EIP"
  }
}

resource "aws_nat_gateway" "student_app_nat_gw" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "StudentAppNatGW"
  }
}

# --- Route Tables ---
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.student_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.student_app_igw.id
  }

  tags = {
    Name = "StudentAppPublicRT"
  }
}

resource "aws_route_table_association" "public_subnet_az1_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.student_app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.student_app_nat_gw.id
  }

  tags = {
    Name = "StudentAppPrivateRT-AZ1"
  }
}

resource "aws_route_table_association" "private_subnet_az1_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = aws_vpc.student_app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.student_app_nat_gw.id
  }

  tags = {
    Name = "StudentAppPrivateRT-AZ2"
  }
}

resource "aws_route_table_association" "private_subnet_az2_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}
