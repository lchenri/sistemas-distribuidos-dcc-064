resource "aws_vpc" "vpc_sistemas_distribuidos" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "vpc_sistemas_distribuidos"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_sistemas_distribuidos.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "it-gw" {
  vpc_id = aws_vpc.vpc_sistemas_distribuidos.id
  tags = {
    name = "it-gw"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_sistemas_distribuidos.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it-gw.id
  }
  tags = {
    name = "rt_public"
  }
}

resource "aws_route_table_association" "a_rt_public" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt_public.id
}