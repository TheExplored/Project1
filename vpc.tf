resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "assignment-vpc"
  }
}
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.mainvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.1.1.0/24"
  tags = {
    Name = "public1-subnet"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.mainvpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.1.2.0/24"
  tags = {
    Name = "public2-subnet"
  }
}
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private1-subnet"
  }
}
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.mainvpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.1.4.0/24"
  tags = {
    Name = "private2-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "assignment-igw"
  }
}
resource "aws_eip" "eip" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "assignment-nat"
  }

}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "PrivateRouteTable"
  }
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
