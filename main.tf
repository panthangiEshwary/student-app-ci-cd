provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}

# Get latest Amazon Linux 2 AMI ID
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# -----------------------------
# VPC Module


module "vpc" {
  source              = "./modules/vpc"
  aws_region          =  var.aws_region
  vpc_cidr_block      = "10.0.0.0/16"
  public_subnet_cidr  = ["10.0.10.0/24","10.0.12.0/24"]
  private_subnet_cidr = ["10.0.14.0/24","10.0.15.0/24"]
}

module "security_groups" {
  source         = "./modules/security_groups"
  vpc_id         = module.vpc.vpc_id
  my_ip_cidr     = var.my_ip_cidr
  alb_sg_id      = module.security_groups.alb_sg_id
}

module "ecr" {
  source = "./modules/ECR"
}

module "ecs" {
  source                = "./modules/ECS"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_fargate_sg_id     = module.security_groups.ecs_fargate_sg_id
  alb_tg_arn            = module.alb.alb_target_group_arn
  ecr_repository_url    = module.ecr.ecr_repository_url
  rds_instance_address  = module.rds.rds_instance_address
  db_endpoint           = module.rds.rds_endpoint
  db_name               = module.rds.db_name
  db_port               = module.rds.db_port
  db_master_username    = var.db_master_username
  db_master_password    = var.db_master_password
  aws_region            = var.aws_region
  aws_account_id        = data.aws_caller_identity.current.account_id
  depends_on            = [module.alb]
  rds_instance_arn           = module.rds.rds_instance_arn
  db_credentials_secret_arn  = module.rds.db_credentials_secret_arn
}


module "rds" {
  source                = "./modules/rds"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_sg_id             = module.security_groups.rds_sg_id
  db_master_username    = var.db_master_username
  db_master_password    = var.db_master_password
  aws_region            = var.aws_region
  aws_account_id        = data.aws_caller_identity.current.account_id
}


module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

module "cloudwatch" {
  source            = "./modules/cloudwatch"
  alb_id            = module.alb.alb_id
  ecs_cluster_name  = module.ecs.ecs_cluster_name
  ecs_service_name  = module.ecs.ecs_service_name
  rds_instance_id   = module.rds.rds_instance_id
  log_group_name    = module.ecs.log_group_name
  aws_region          =  var.aws_region
}

# -----------------------------
# Bastion Host Module
# -----------------------------

module "bastion" {
  source           = "./modules/bastion"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  sg_id            = module.security_groups.bastion_sg_id
  ami_id           = data.aws_ami.amazon_linux_2.id
  key_pair_name    = "N.V"
}