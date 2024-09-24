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
    source               = "./modules/vpc"
    vpc_cidr             = var.vpc_cidr
    public_subnet_count  = var.public_subnet_count
    private_subnet_count = var.private_subnet_count
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs 
}

module "web-server" {
    source     = "./modules/ec2"
    ami_id     = local.ami_id
    subnet_id  = module.vpc.public_subnet_id[0]
    depends_on = [module.database]
}
module "database" {
    source    = "./modules/db_ec2"
    ami_id    = local.ami_id
    subnet_id = module.vpc.private_subnet_id[0]
}
