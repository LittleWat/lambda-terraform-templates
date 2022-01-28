resource "aws_vpc" "main_lambda" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.service_name}-vpc"
  }
}

resource "aws_subnet" "main_lambda_public_subnet_1a" {
  vpc_id            = aws_vpc.main_lambda.id
  cidr_block        = cidrsubnet(aws_vpc.main_lambda.cidr_block, 8, 0)
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.service_name}-public-${var.region}a"
  }
}

resource "aws_subnet" "main_lambda_private_subnet_1a" {
  vpc_id            = aws_vpc.main_lambda.id
  cidr_block        = cidrsubnet(aws_vpc.main_lambda.cidr_block, 8, 1)
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.service_name}-private-${var.region}a"
  }
}

resource "aws_subnet" "main_lambda_public_subnet_1c" {
  vpc_id            = aws_vpc.main_lambda.id
  cidr_block        = cidrsubnet(aws_vpc.main_lambda.cidr_block, 8, 2)
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.service_name}-public-${var.region}c"
  }
}

resource "aws_subnet" "main_lambda_private_subnet_1c" {
  vpc_id            = aws_vpc.main_lambda.id
  cidr_block        = cidrsubnet(aws_vpc.main_lambda.cidr_block, 8, 3)
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.service_name}-private-${var.region}c"
  }
}

resource "aws_internet_gateway" "main_lambda" {
  vpc_id = aws_vpc.main_lambda.id

  tags = {
    Name = "${var.service_name}-igw"
  }
}

resource "aws_route_table" "main_lambda_public" {
  vpc_id = aws_vpc.main_lambda.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_lambda.id
  }

  tags = {
    Name = "${var.service_name}-public-rt"
  }
}


## 1a
resource "aws_route_table_association" "main_lambda_public_1a" {
  subnet_id      = aws_subnet.main_lambda_public_subnet_1a.id
  route_table_id = aws_route_table.main_lambda_public.id
}

resource "aws_eip" "main_lambda_1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.main_lambda]
  tags = {
    Name = "${var.service_name}-eip-1a"
  }
}

resource "aws_nat_gateway" "main_lambda_1a" {
  allocation_id = aws_eip.main_lambda_1a.id
  subnet_id     = aws_subnet.main_lambda_public_subnet_1a.id

  tags = {
    Name = "${var.service_name}-ngw-1a"
  }
}

resource "aws_route_table" "main_lambda_private_1a" {
  vpc_id = aws_vpc.main_lambda.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_lambda_1a.id
  }

  tags = {
    Name = "${var.service_name}-private-rt-1a"
  }
}

resource "aws_route_table_association" "main_lambda_private_1a" {
  subnet_id      = aws_subnet.main_lambda_private_subnet_1a.id
  route_table_id = aws_route_table.main_lambda_private_1a.id
}

## 1c

resource "aws_route_table_association" "main_lambda_public_1c" {
  subnet_id      = aws_subnet.main_lambda_public_subnet_1c.id
  route_table_id = aws_route_table.main_lambda_public.id
}

resource "aws_eip" "main_lambda_1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.main_lambda]
  tags = {
    Name = "${var.service_name}-eip-1c"
  }
}

resource "aws_nat_gateway" "main_lambda_1c" {
  allocation_id = aws_eip.main_lambda_1c.id
  subnet_id     = aws_subnet.main_lambda_public_subnet_1c.id

  tags = {
    Name = "${var.service_name}-ngw-1c"
  }
}

resource "aws_route_table" "main_lambda_private_1c" {
  vpc_id = aws_vpc.main_lambda.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_lambda_1c.id
  }

  tags = {
    Name = "${var.service_name}-private-rt-1c"
  }
}

resource "aws_route_table_association" "main_lambda_private_1c" {
  subnet_id      = aws_subnet.main_lambda_private_subnet_1c.id
  route_table_id = aws_route_table.main_lambda_private_1c.id
}


## acl
resource "aws_default_network_acl" "default_network_acl" {
  default_network_acl_id = aws_vpc.main_lambda.default_network_acl_id
  subnet_ids = [
    aws_subnet.main_lambda_public_subnet_1a.id,
    aws_subnet.main_lambda_private_subnet_1a.id,
    aws_subnet.main_lambda_public_subnet_1c.id,
    aws_subnet.main_lambda_private_subnet_1c.id,
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.service_name}-default-network-acl"
  }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.main_lambda.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.service_name}-default-security-group"
  }
}
