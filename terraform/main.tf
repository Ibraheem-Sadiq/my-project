terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
}

module "vpc" {
  source                 = "./modules/VPC"
  vpc_cidr               = var.vpc_cidr
  public_subnets_config  = var.public_subnets_config
  private_subnets_config = var.private_subnets_config
  vpc_name               = var.vpc_name
} 
resource "aws_iam_role" "block_iam_role" {
    name = "iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },    
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
module "security_group" {
  source = "./modules/sg"
  vpc_id = module.vpc.out_vpc_id
}

module "jenkin" {
  source = "./modules/ec2"
  vpc_id = module.vpc.out_vpc_id
  ami = var.ec2_ami
  type = var.ec2_type
  sg = module.security_group.sg_id
  sub_id = module.vpc.out_public_subnet_ids[0]
depends_on = [ module.security_group,module.vpc ]
}


module "backup_plan" {
  source = "./modules/backup_plan"
  iam_role_arn = aws_iam_role.block_iam_role.arn
  ec2 = [module.jenkin.jenkins_id]
  schedule = var.backup_sechdule
  depends_on = [ module.jenkin]
}

module "eks" {
  source = "./modules/eks"
  iam_role_arn = aws_iam_role.block_iam_role.arn
  addons = var.eks_addons
  sub_ids = module.vpc.out_public_subnet_ids
  depends_on = [ module.vpc,aws_iam_role.block_iam_role ]
}


resource "aws_s3_bucket" "block_s3" {
  bucket = "block-s3"

  tags = {
    Name = "s3-log"
  }
}

# module "elb" {
#   source = "./modules/elb"
#   vpc_id = module.vpc.out_vpc_id
#   sg = module.security_group.sg_id
#   subnets = [module.vpc.out_public_subnet_ids[*], module.vpc.out_private_subnet_ids[*]]
#   depends_on = [ module.vpc,module.security_group,aws_s3_bucket.block_s3 ]
# }

resource "aws_ecr_repository" "block_ecr" {
  name = "block-ecr"
}

