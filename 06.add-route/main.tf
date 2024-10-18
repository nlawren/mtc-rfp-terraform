resource "aws_vpc" "rfp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev.vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "rfp_public_subnet" {
  vpc_id                  = aws_vpc.rfp_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "dev.public_subnet"
  }
}

resource "aws_internet_gateway" "rfp_internet_gateway" {
  vpc_id = aws_vpc.rfp_vpc.id

  tags = {
    Name = "dev.igw"
  }
}

resource "aws_route_table" "rfp_public_rt" {
  vpc_id = aws_vpc.rfp_vpc.id

  tags = {
    Name = "dev.public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.rfp_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rfp_internet_gateway.id
}