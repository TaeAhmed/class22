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

resource "aws_subnet" "subnet" {
  vpc_id     = "${module.vpc.vpc_id}"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Main"
  }
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
