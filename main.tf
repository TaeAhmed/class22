terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
}

provider "aws" {
    region = local.region
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
    count = 3
    vpc_id     = "${module.vpc.vpc_id}"
    cidr_block = element(var.public_subnet_cidrs, count.index)
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
    count = 3
    vpc_id     = "${module.vpc.vpc_id}"
    cidr_block = element(var.private_subnet_cidrs, count.index)
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
    vpc_id = module.vpc.vpc_id
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public[0].id
}

resource "aws_eip" "nat_eip" {
    vpc = true
}

resource "aws_route_table" "public" {
    vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "private" {
    vpc_id = module.vpc.vpc_id
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
    count = 3
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = 3
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

module "web-server" {
    source = "./modules/ec2"
    ami_id = local.ami_id
    instance_type = "t2.micro"
    subnet_id = "" #some public subnet id
    depends_on = [module.database]
}
module "database" {
    source = "./modules/ec2"
    ami_id = local.ami_id
    instance_type = "db.t2.micro"
    subnet_id = "" #some private subnet id
    prevent_destroy = true

}
