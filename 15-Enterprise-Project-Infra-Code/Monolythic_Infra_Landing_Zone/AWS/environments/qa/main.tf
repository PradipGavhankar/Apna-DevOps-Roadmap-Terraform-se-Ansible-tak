module "landing_zone" {
  source = "../../modules/landing-zone"

  aws_region           = var.aws_region
  project_name         = var.project_name
  environment          = "qa"
  owner                = var.owner
  tags                 = var.tags
  availability_zones   = var.availability_zones
  vpc_cidr             = var.vpc_cidr
  subnet_cidrs         = var.subnet_cidrs
  nat_gateway_mode     = var.nat_gateway_mode
  acm_certificate_arn  = var.acm_certificate_arn
  instance_type        = var.instance_type
  asg_min_size         = var.asg_min_size
  asg_desired_capacity = var.asg_desired_capacity
  asg_max_size         = var.asg_max_size
}
