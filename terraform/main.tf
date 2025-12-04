module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
}

module "networking" {
  source         = "./modules/networking"
  vpc_id         = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  environment    = var.environment
}

module "security_groups" {
  source      = "./modules/vpcgroup"  # <-- Change to this if not renaming folder; otherwise "./modules/security-groups"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "waf" {
  source      = "./modules/waf"
  environment = var.environment
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = module.security_groups.alb_sg_id
  waf_arn         = module.waf.waf_arn
  environment     = var.environment
}