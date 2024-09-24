resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy
  tags = {Name = "main"}
}

resource "aws_subnet" "public" {
    count                   = var.public_subnet_count
    vpc_id                  = aws_vpc.main.id
    cidr_block              = element(var.public_subnet_cidrs, count.index)
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
    count                   = var.private_subnet_count
    vpc_id                  = aws_vpc.main.id
    cidr_block              = element(var.private_subnet_cidrs, count.index)
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public[0].id
}

resource "aws_eip" "nat_eip" {
    vpc = true
    tags = { Name = "nat_eip"}
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "public" {
    count = var.public_subnet_count
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = var.private_subnet_count
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

