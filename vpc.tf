resource "aws_vpc" "busha_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "busha-vpc"
  }
}


resource "aws_subnet" "busha_subnet1" {
  vpc_id            = aws_vpc.busha_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "busha-subnet1"
  }
}

resource "aws_subnet" "busha_subnet2" {
  vpc_id            = aws_vpc.busha_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "busha-subnet2"
  }
}

resource "aws_subnet" "busha_subnet3" {
  vpc_id            = aws_vpc.busha_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "busha-subnet3"
  }
}

resource "aws_internet_gateway" "busha_igw" {
  vpc_id = aws_vpc.busha_vpc.id

  tags = {
    Name = "busha-igw"
  }
}


resource "aws_eip" "busha_eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "busha_nat_gateway" {
  allocation_id = aws_eip.busha_eip.id
  subnet_id     = aws_subnet.busha_subnet1.id

  tags = {
    Name = "busha-nat-gateway"
  }

  depends_on = [aws_internet_gateway.busha_igw]
}


resource "aws_route_table" "busha_public_rt" {
  vpc_id = aws_vpc.busha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.busha_igw.id
  }

  tags = {
    Name = "busha-public-rt"
  }
}

resource "aws_route_table" "busha_private_rt" {
  vpc_id = aws_vpc.busha_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.busha_nat_gateway.id
  }

  tags = {
    Name = "busha-private-rt"
  }
}


resource "aws_route_table_association" "busha_subnet1_association" {
  subnet_id      = aws_subnet.busha_subnet1.id
  route_table_id = aws_route_table.busha_public_rt.id
}

resource "aws_route_table_association" "busha_subnet2_association" {
  subnet_id      = aws_subnet.busha_subnet2.id
  route_table_id = aws_route_table.busha_public_rt.id
}

resource "aws_route_table_association" "busha_subnet3_association" {
  subnet_id      = aws_subnet.busha_subnet3.id
  route_table_id = aws_route_table.busha_public_rt.id
}
